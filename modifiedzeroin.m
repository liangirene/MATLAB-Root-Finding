function [root,info] = modifiedzeroin(func,Int,params)
%
% Modified zero-in for root-finding
%
% Finds a root of the equation f(x) = 0
%
% On input:
%   func: a function handle
%   Int: initial interval ([Int.a,Int.b])
%   params: object that contains params.root_tol, params.func_tol and params.maxit
%
% On output:
%   root: computed root
%   info: it (number of iterations), flag (0 for successful execution; 1 otherwise)
%
% Written by Irene Liang for MATH 128A, Fall 2022
%

% Initialize.
a = Int.a;
b = Int.b;
x0 = a;
x1 = b;
x2 = (x0+x1)/2;
fa = func(a); % Calculate f(a)
fb = func(b); % Calculate f(b)
fx0 = fa;
fx1 = fb;
fx2 = func(x2);
fc = fx2;
c = x2;
prev_f = [];

info.it = 0;

if fa*fb >= 0 % Need f(a)*f(b)<0
    error('Function must change sign on the interval.');    
end            
 
% Main loop
while abs(b - a) > params.root_tol && info.it < params.maxit % repeat until |b − a| < root_tol (convergence) & doesn't exceed max number of iteration
    x3 = x0*fx1*fx2/((fx0 - fx1)*(fx0 - fx2)) + x1*fx0*fx2/((fx1 - fx0)*(fx1 - fx2)) + x2*fx0*fx1/((fx2 - fx0)*(fx2 - fx1)); % x3=IQI(a,b,c)
    if (x3<=a || x3>=b) % if x3 is not in [a,b]
        for i = 1:5
            c = (a+b)/2; fc = func(c);
            if (fa*fc) < 0 % a few bisection steps and bisect (a,b)
                b = c; fb = fc;
            else
                a = c; fa = fc; 
            end
        end
        c = (a+b)/2; fc = func(c);
        x0 = a; x1 = b; x2 = c;
        fx0 = fa; fx1 = fb; fx2 = fc;
        continue
    end
    
    fx3 = func(x3);
    x0 = x1; x1 = x2; x2 = x3;
    fx0 = fx1; fx1 = fx2; fx2 = fx3;

    if abs(fx2) < params.func_tol % Function value at the current iterate is at most params.func_tol in abs value.
        root = x2;
        info.flag = 0;
        return
    end

    xval = [x0, x1, x2];
    fval = [fx0, fx1, fx2];
    [~, mini] = min(xval);
    [~, maxi] = max(xval);
    if (fval(mini)*fval(maxi)) < 0
        a = xval(mini);
        b = xval(maxi);
    elseif (fval(mini)*fb) < 0
        a = xval(mini); fa = fval(mini);
        b = b; fb = fb;
    else
        a = a; fa = fa;
        b = xval(maxi); fb = fval(maxi);
    end

    prev_f = [prev_f, fx2];
    if length(prev_f) >= 5 && (prev_f(1) < 2*prev_f(end)) 
        prev_f = [];
        for i = 1:3
            c = (a+b)/2; fc = func(c);
            if (fa*fc) < 0 % a few bisection steps and bisect (a,b)
                b = c; fb = fc;
            else
                a = c; fa = fc;
            end
        end
        c = (a+b)/2; fc = func(c);
        x0 = a; x1 = b; x2 = c;
        fx0 = fa; fx1 = fb; fx2 = fc;
    else
        prev_f = prev_f(2:end);
    end

    info.it = info.it + 1;
end

if info.it > params.maxit
    root = c;
    info.flag = 1;
    return
end

info.flag = 0;
root = c;
