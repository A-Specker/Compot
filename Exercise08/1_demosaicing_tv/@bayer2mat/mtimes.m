function y = mtimes(obj, x)

if obj.tp
    y = zeros(size(x,1), size(x,2), 3);                 % RGB
    y(1:2:end,1:2:end,1) = x(1:2:end,1:2:end,1);
    y(2:2:end,2:2:end,3) = x(2:2:end,2:2:end,3);
    y(1:2:end,2:2:end,2) = x(1:2:end,2:2:end,2);
    y(2:2:end,1:2:end,2) = x(2:2:end,1:2:end,2);
else
    y = zeros(size(x,1), size(x,2), 3);                    % RAW
    y(1:2:end,1:2:end, 1) = x(1:2:end,1:2:end,1);
    y(2:2:end,2:2:end, 3) = x(2:2:end,2:2:end,3);
    y(1:2:end,2:2:end, 2) = x(1:2:end,2:2:end,2);
    y(2:2:end,1:2:end, 2) = x(2:2:end,1:2:end,2);
end

return
