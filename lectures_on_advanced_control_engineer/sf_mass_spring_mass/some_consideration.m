

%% version 1
Ade = [[0 0 0] 0; Bd Ad];
Bde = [1; [0 0 0]'];
Q=...;
R=...;
K_hat = dlqr(Ade,Bde,Q,R);
Kd = (K_hat+[1 0 0 0])/([C*Bd C*Ad; Bd Ad-eye(3)]);
ki = Kd(1)
Kx = [Kd(2) Kd(3) Kd(4)]
Kx_ff = [Kx -1]

%% version 2
Ade = [Ad Bd; [0 0 0] 0];
Bde = [[0 0 0]';1];
Q=...;
R=...;
K_hat = dlqr(Ade,Bde,Q,R);
Kd = (K_hat+[0 0 0 1])/([Ad-eye(3) Bd; C*Ad C*Bd]);
ki = Kd(4)
Kx = [Kd(1) Kd(2) Kd(3)]
Kx_ff = [Kx -1]