m = 0;
function [c, f, s] = pdefun(x, t, u, dudx)
  c = 1;
  f = u;
  s = 0;
endfunction

function [pl, ql, pr, qr] = bcfun(xl, ul, xr, ur, t)
  pl = ul;
  ql = 1;
  pr = ur;
  qr = 1;
endfunction

sol = pde1dm(m, pdefun, @(x)(sin(x)), @(t)(-sin(t)), xmesh, tspan)
