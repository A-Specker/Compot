function y = mtimes(obj, x)

if obj.tp
  % transposed
  switch obj.shape
    case 'same'
      gx = x{1};
      gy = x{2};

      y = - gx - gy;
      y(:,2:end) = y(:,2:end) + gx(:,1:end-1);
      y(2:end,:) = y(2:end,:) + gy(1:end-1,:);
      y = y / sqrt(2.);
    case 'valid'
      error('Not implemented yet');
  end
  
else
  switch obj.shape
    case 'same'
      xp = padarray(x, [1,1], 'post');  
      gx = (xp(1:end-1,2:end)-x)/sqrt(2.);
      gy = (xp(2:end,1:end-1)-x)/sqrt(2.);
    case 'valid'
      gx = (x(:,2:end)-x(:,1:end-1))/sqrt(2.);
      gy = (x(2:end,:)-x(1:end-1,:))/sqrt(2.);
  end
  y = {gx, gy};
  
end
return
