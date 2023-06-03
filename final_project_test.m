% README
% 1. put the test file and your function file in the same directory
% 2. run final_project_test.m
% 3. If your modifiedzeroin finds an appropriate root(in [a,b], satisfies
%       two tolerances), it will print out some observables from your
%       execution
% 4. If not, (especially your modifiedzeroin faces a fatal error) it
%       will notify you.
% 5. The reference value is the desirable number of function calls during
%       the root finding procedure. The number may vary based on the
%       hyper-parameter setting. So +1~+2 (or *1.2) would be fine. If not,
%       please check your implementation.
clear

% function name
funName = append('modifiedzeroin', num2str(SID));

%Set up test cases
params.root_tol = 1e-9; params.func_tol = 1e-9; params.maxit = 100;
test_functions{1} = @(x) sqrt(x)-cos(x); test_intervals{1} = [0.0, 1.0]; test_it(1)=7;
test_functions{2} = @(x) 3*(x+1)*(x-0.5)*(x-1); test_intervals{2} = [-2, 0.2]; test_it(2) = 11;
test_functions{3} = @(x) log(x-1); test_intervals{3} = [1.5, 1e3]; test_it(3) = 19;
test_functions{4} = @(x) pi+5*sin(x/2)-x; test_intervals{4} = [0.0, 6.3]; test_it(4) = 10;
test_functions{5} = @(x) (x-4)^7*(x-2)^11; test_intervals{5} = [1.8, 3.4]; test_it(5) = 15;

%% Get Results
failure_list = {};
profile on
%%%%%%%%%%%%%%%%%%%%%%%%
% Add the initialization
clear roots fcalls roots_results fcalls_results
% Raehyun
%%%%%%%%%%%%%%%%%%%%%%%%

nfun = length(test_functions);
failed = zeros(nfun,1);
disp(funName);
for j = 1:nfun
    Int.a = test_intervals{j}(1); Int.b = test_intervals{j}(2);
    myfunctionstring = [funName, '(test_functions{j}, Int, params);'];
    try
        profile on
        [root, info] = eval(myfunctionstring);
        profile off
        
        %%%%%%%%%%%%%%%%%%%%%%%%
        % When root is not numeric, put an invalid value.
        %%%%%%%%%%%%%%%%%%%%%%%%
        if (isnumeric(root) == 0 || isempty(root))
            root = Int.b+10;
        end
        
        %Store Roots
        roots(1, j) = root;
        %Grade Roots
        if or(isnan(root), isinf(root))
            fcalls(1, j) = inf;
            roots_results(1, j) = 0;
            fcalls_results(1, j) = 0;
        else
            root_tol_check = abs(root - fzero(test_functions{j}, root)) < params.root_tol*2.0;
            func_tol_check = abs(test_functions{j}(root)) < params.func_tol;
            int_check = (root > Int.a) & (root < Int.b);
            %%%%%%%%%%%%%%%%%%%%%%%%
            % Modified to return 0 value when it can't find a proper root
            % root_tol_check OR func_tol_check
            %%%%%%%%%%%%%%%%%%%%%%%%
            if (root_tol_check || func_tol_check) && int_check
                roots_results(1, j) = 1;
            else
                roots_results(1, j) = 0;
            end
            %Store Number of Function Calls
            p = profile('info');
            blah = {p.FunctionTable.CompleteName};
            coo = strfind(blah, func2str(test_functions{j}));
            fcall_idx = find(~cellfun(@isempty, coo));
            fcalls(1, j) = p.FunctionTable(fcall_idx).NumCalls;
            %%%%%%%%%%%%%%%%%%%%%%%%
            % Modified to return 0 value when it can't find a proper root
            %%%%%%%%%%%%%%%%%%%%%%%%
            if (root_tol_check || func_tol_check) && int_check
                fcalls_results(1, j) = fcalls(1,j);
            else
                fcalls_results(1, j) = 0;
            end
        end
    catch
        failed(j) = 1;
        roots_results(j) = 0; roots(j) = 0; fcalls(j) =0; 
    end
    %%%%%%%%%%%%%%%%%%
    % Print result
    %%%%%%%%%%%%%%%%%%
    fprintf('========================\n')
    fprintf('Fun %d result\n', j)
    if failed(j)
        fprintf('Failed \n');
    else
        if roots_results(j)
            fprintf('Root %f within [%f,%f] with f(root)=%e\n', roots(j), Int.a, Int.b, test_functions{j}(roots(j)))
        else
            fprintf('Failed to find root %f within [%f,%f]\n', roots(j), Int.a, Int.b)
        end
        fprintf('function calls : %d \t reference : %d \n', fcalls(j), test_it(j))
    end
end


