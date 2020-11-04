function output = callbaron(model)

% This sets up everything and more. Can be simplified significantly since
% baron handles its own computational tree etc
model = yalmip2nonlinearsolver(model);

% [Anonlinear*f(x) <= b;Anonlinear*f(x) == b]
cu = full([model.bnonlinineq;model.bnonlineq]);
cl = full([repmat(-inf,length(model.bnonlinineq),1);model.bnonlineq]);
Anonlinear = [ model.Anonlinineq; model.Anonlineq];

% Create string representing objective
obj = createmodelstring(model.c,model);
obj = strrep(obj,'sqrtm_internal','sqrt');
obj = strrep(obj,'cabs','abs');
if nnz(model.Q)>0
    obj = [obj '+' createQstring(model.Q,model)];
end
if model.f > 0
    obj = [obj '+' num2str(model.f)];
end
% YALMIP ctches log(1+z) and implements internal model slog(z) 
% Replace with log
expression = 'slog((\w*)';
replace = 'log(1+$1';
obj =  regexprep(obj,expression,replace);
if length(obj)>0
    obj = strrep(obj,'+-','-');
    obj = ['@(x) ' obj];
    obj = eval(obj);
else
    obj = @(x)0;
end

% Create string representing nonlinear consdbqtraints
if length(cu)>0
    con = '[';
    remove = [];
    for i = 1:length(cu)
        if isinf(cl(i)) & isinf(cu(i))
            remove = [remove;i];
        else
            con = [con createmodelstring(Anonlinear(i,:),model) ';'];
        end
    end
    cl(remove) = [];
    cu(remove) = [];
    con = [con ']'];
    con = strrep(con,'sqrtm_internal','sqrt');
    con =  regexprep(con,expression,replace);
    con = ['@(x) ' con];
    con = eval(con);
else
    cu = [];
    cl = [];
    con = [];
end

% Linear constraints
ru = full([model.b;model.beq]);
rl = full([repmat(-inf,length(model.b),1);model.beq]);
A =  [model.A; model.Aeq];
if length(ru)>0
    remove = find(isinf(rl) & isinf(ru));
    A(remove,:)=[];
    rl(remove) = [];
    ru(remove) = [];
end

lb = model.lb;
ub = model.ub;

xtype = [];
xtype = repmat('C',length(lb),1);
xtype(model.binary_variables) = 'B';
xtype(model.integer_variables) = 'I';
x0 = model.x0;
opts = model.options.baron;
opts.prlevel = model.options.verbose;
if model.options.savedebug    
    save barondebug obj con A ru rl cl cu lb ub x0 opts
end

solvertime = tic;
[x,fval,exitflag,info,allsol] = baron(obj,A,rl,ru,lb,ub,con,cl,cu,xtype,x0,opts);
solvertime = toc(solvertime);

% Check, currently not exhaustive...
switch exitflag
    case 1
        problem = 0;
    case 2
        problem = 1;
    case 3
        problem = 2;
    case 4
        problem = 3;
    case 5
        problem = 11;
    otherwise
        problem = 9;
end

% Save all data sent to solver?
if model.options.savesolverinput
    solverinput.obj = obj;
    solverinput.A = A;
    solverinput.rl = rl;
    solverinput.ru = ru;
    solverinput.lb = lb;
    solverinput.ub = ub;
    solverinput.con = con;
    solverinput.cl = cl;
    solverinput.cu = cu;
    solverinput.xtype = xtype;
    solverinput.opts = opts;
else
    solverinput = [];
end

% Save all data from the solver?
if model.options.savesolveroutput
    solveroutput.x = x;
    solveroutput.fval = fval;
    solveroutput.exitflag = exitflag;
    solveroutput.info=info;
    solveroutput.allsol=allsol;
else
    solveroutput = [];
end

if ~isempty(x)
    x = RecoverNonlinearSolverSolution(model,x);
end

% Standard interface
output = createoutput(x,[],[],problem,'BARON',solverinput,solveroutput,solvertime);



function z = createOneterm(i,model)

[evalPos,pos] = ismember(i,model.evalVariables);
if pos
    % This is a nonlinear operator
    map = model.evalMap{pos};
    % We might hqave vectorized things to compute several expressions at the same time
    if strcmp(model.evalMap{pos}.fcn,'sum_square')
        z = ['('];                
        for j = map.variableIndex
            jl = find(model.linearindicies == j);
            if isempty(jl)
                z =  [z '(' createmonomstring(model.monomtable(j,:),model) ')^2+'];
            else
                z =  [z 'x(' num2str(jl) ')^2+'];
            end 
        end
        z = [z(1:end-1) ')'];
    elseif strcmp(model.evalMap{pos}.fcn,'entropy')
        z = ['('];                
        for j = map.variableIndex
            jl = find(model.linearindicies == j);
            if isempty(jl)
                z =  [z '(' createmonomstring(model.monomtable(j,:),model) ')^2+'];
            else
                z =  [z '-x(' num2str(jl) ')*log(x(' num2str(jl) '))+'];
            end 
        end
        z = [z(1:end-1) ')'];        
    else
        j = find(map.computes == i);
        j = map.variableIndex(j);
        % we have f(x(j)), but have to map back to linear indicies
        jl = find(model.linearindicies == j);
        if isempty(jl)
            z =  [map.fcn '(' createmonomstring(model.monomtable(j,:),model)  ')'];
        else
            z =  [map.fcn '(x(' num2str(jl) '))'];
        end
    end
else
    i = find(model.linearindicies == i);
    z =  ['x(' num2str(i) ')'];
end

function monomstring = createmonomstring(v,model)

monomstring = '';
for i = find(v)
    z = createOneterm(i,model);
    if v(i)==1
        monomstring = [monomstring z '*'];
    else
        monomstring = [monomstring z '^' num2str(v(i),12) '*'];
    end
end
monomstring = monomstring(1:end-1);


function string = createmodelstring(row,model)
string = '';
index = find(row);
for i = index(:)'
    monomstring = createmonomstring(model.monomtable(i,:),model);
    string = [string  num2str(row(i),12) '*' monomstring '+'];
end
string = string(1:end-1);
string = strrep(string,'+-','-');
string = strrep(string,')-1*',')-');
string = strrep(string,')+1*',')+');

function string = createQstring(Q,model)
% Special code for the quadratic term
string = '';
[ii,jj,c]= find(triu(Q));
for i = 1:length(ii)
    if ii(i)==jj(i)
        % Quadratic term
        monomstring = createmonomstring(sparse(1,ii(i),1,1,size(Q,1)),model);       
        string = [string  num2str(c(i),12) '*' monomstring '^2' '+'];
    else
        % Bilinear term
        monomstring1 = createmonomstring(sparse(1,ii(i),1,1,size(Q,1)),model);
        monomstring2 = createmonomstring(sparse(1,jj(i),1,1,size(Q,1)),model);
        string = [string  num2str(c(i),12) '*2*' monomstring1 '*' monomstring2 '+'];
    end
end
string = string(1:end-1);
string = strrep(string,'+-','-');
string = strrep(string,'-1*','-');
string = strrep(string,'+1*','+');


