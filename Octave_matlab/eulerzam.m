function [y,t] = eulerzam(f,x0, t0, h, n)
    t = t0+h*(0:n);
    y=zeros(1,n);
    y(1)=x0;
    for i = 2:n
      ftosolve = @(x)(x-y(i-1) + h*feval(f,t(i-1),y(i-1)));
      y(i) = fzero(ftosolve,y(i-1));
    endfor
  end