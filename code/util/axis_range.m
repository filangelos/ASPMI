function [xmin, xmax, ymin, ymax] = axis_range(x, y, a)
    % prettify axis ranges
    xrange = max(x) - min(x);
    xmin = min(x)-a*xrange;
    xmax = max(x)+a*xrange;
    yrange = max(y) - min(y);
    ymin = min(y)-a*yrange;
    ymax = max(y)+a*yrange;
end