clear all
close all
clc
beep off


ts = 1e-4;
T = 20e-3;
time = [0:ts:4*T];
N = length(time);
theta = 2*pi/T*time;
ualpha = sqrt(3)/2 * cos(theta);
ubeta = sqrt(3)/2 * cps(theta-pi/2);
figure; 
plot(time, ualpha, time, ubeta);
grid on

ua = zeros(1,N);
ub = zeros(1,N);
uc = zeros(1,N);
t0 = zeros(1,N);
t1 = zeros(1,N);
t2 = zeros(1,N);
sector_ref = zeros(1,N);
ref_alpha = zeros(1,N);
ref_beta = zeros(1,N);
up = ones(1,N);
for i=1:N
    ua(i) = ualpha(i);
    ub(i) = (-1/2*ualpha(i) + sqrt(3)/2*ubeta(i));
    uc(i) = (-1/2*ualpha(i) - sqrt(3)/2*ubeta(i));
end
figure; 
plot(time, ua, time, ub, time, uc);
grid on

% sector constraints
for i=1:N

    ref_alpha(i) = abs(ualpha(i))*sqrt(3)/2;
    ref_beta(i) = abs(ubeta(i))/2;
    angle = atan2(ubeta(i),ualpha(i));
    
    if (angle >= 0 && angle <= pi/3)
        % sector1 (counterclockwise)
        sector_ref(i) = 1;
        t2(i) = ubeta(i)*2/sqrt(3); %v2
        t1(i) = ualpha(i) - ubeta(i)/sqrt(3); %v1
        t0(i) = up(i) - t2(i) - t1(i);
        ua(i) = t0(i)/2;
        ub(i) = t1(i) + ua(i);
        uc(i) = t2(i) + ub(i);
    end
    if (angle >= pi/3 && angle <= 2*pi/3)
        % sector2 (clockwise)
        sector_ref(i) = 2;
        t1(i) = -ualpha(i) + ubeta(i)/sqrt(3); %v3
        t2(i) = ualpha(i) + ubeta(i)/sqrt(3); %v2
        t0(i) = up(i) - t2(i) - t1(i);
        ub(i) = t0(i)/2;
        ua(i) = t1(i) + ub(i);
        uc(i) = t2(i) + ua(i);
    end
    if (angle >= 2*pi/3 && angle <= pi)
        % sector3 (counterclockwise)
        sector_ref(i) = 3;
        t2(i) = -ubeta(i)/sqrt(3) - ualpha(i); %v4
        t1(i) = ubeta(i)*2/sqrt(3); %v3
        t0(i) = up(i) - t2(i) - t1(i);
        ub(i) = t0(i)/2;
        uc(i) = t1(i) + ub(i);
        ua(i) = t2(i) + uc(i);
    end
    if (angle >= -pi && angle <= -2*pi/3)
        % sector4 (clockwise)
        sector_ref(i) = 4;
        t1(i) = -2/sqrt(3)*ubeta(i); %v5
        t2(i) = ubeta(i)/sqrt(3) - ualpha(i); %v4
        t0(i) = up(i) - t2(i) - t1(i);
        uc(i) = t0(i)/2;
        ub(i) = t1(i) + uc(i);
        ua(i) = t2(i) + ub(i);
    end

    if (angle >= -2*pi/3 && angle <= -pi/3)
        % sector5 (counterclockwise)
        sector_ref(i) = 5;
        t2(i) = ualpha(i) - 1/sqrt(3)*ubeta(i); %v6
        t1(i) = -ualpha(i) - 1/sqrt(3)*ubeta(i); %v5
        t0(i) = up(i) - t2(i) - t1(i);
        uc(i) = t0(i)/2;
        ua(i) = t1(i) + uc(i);
        ub(i) = t2(i) + ua(i);
    end
    if (angle >= -pi/3 && angle <= 0)
        % sector6 (clockwise)
        sector_ref(i) = 6;
        t1(i) = ualpha(i) + ubeta(i)/sqrt(3); %v1
        t2(i) = -ubeta(i)*2/sqrt(3); %v6
        t0(i) = up(i) - t2(i) - t1(i);
        ua(i) = t0(i)/2;
        uc(i) = t1(i) + ua(i);
        ub(i) = t2(i) + uc(i);
    end
end

% plot results
figure; 
subplot 221
plot(time, ua);
grid on
subplot 222
plot(time, ub);
grid on
subplot 223
plot(time, uc);
grid on
subplot 224
plot(time, sector_ref);
grid on