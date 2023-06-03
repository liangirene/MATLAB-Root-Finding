# MATLAB-Root-Finding

In this project, I optimized the root-finding process by modifying the MATLAB built-in zero-in function. By implementing specific enhancements, I successfully reduced the number of iterations needed to find the root within the defined tolerance parameter. This modification resulted in improved efficiency and accuracy in the root-finding process.


We would like to find a root of the equation
<pre>
        f(x) = 0, for x ∈ ℝ
</pre>
given an initial interval [a,b] with
<pre>
        f(a) · f(b) < 0 
</pre>
with a combination of two methods: 
- Bisection method, for its reliability
- [Inverse quadratic interpolation (IQI) method](https://en.wikipedia.org/wiki/Inverse_quadratic_interpolation), for its higher order of convergence: Given three pairs of points (x_0, f_0) , (x_1, f_1) , (x_2, f_2), IQI defines
a quadratic polynomial in *f* that goes through these points
