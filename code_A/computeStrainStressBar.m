function [eps,sig] = computeStrainStressBar(n_d,n_el,u,Td,x,Tn,mat,Tmat)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
%   - u     Global displacement vector [n_dof x 1]
%            u(I) - Total displacement on global DOF I
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - eps   Strain vector [n_el x 1]
%            eps(e) - Strain of bar e
%   - sig   Stress vector [n_el x 1]
%            sig(e) - Stress of bar e
%--------------------------------------------------------------------------

eps=zeros(n_el,1);
sig=zeros(n_el,1);

for e=1:n_el
    ue=zeros(2*2,1);
    x1e=x(Tn(e,1),1);
    y1e=x(Tn(e,1),2);
    x2e=x(Tn(e,2),1);
    y2e=x(Tn(e,2),2);
    le=sqrt((x2e-x1e)^2+(y2e-y1e)^2);
    se=(y2e-y1e)/le;
    ce=(x2e-x1e)/le;
    Re=[ce se 0 0 
        -se ce 0 0 
        0 0 ce se
        0 0 -se ce];
    for i=1:2*2
        I=Td(e,i);
        ue(i,1)=u(I);
    end
    uep=Re*ue;
    eps(e,1)=(1/le)*[-1 0 1 0]*uep;
    sig(e,1)=mat(Tmat(e),1)*eps(e,1);
end


end