%% Optimal Insulin Dosing for Glucose Regulation

% Define Variables
N      = 40;
a      = 0.98;
b      = -0.005;
d      = 0.1;
G_init = 180;
G_star = 110;
alpha  = 1e-3;

% Define Bounds
U_min  = 0;
U_max  = 1.0;
G_min  = 70;
G_max  = 200;

% Define Meal Sequence
M = zeros(N,1);
M(10) = 60;
M(25) = 50;
M(35) = 40;
M(1:9) = 5;

U0 = 0.2 * ones(N,1); % initial guess

simulate_glucose = @(U) simulateG(U, a, b, d, G_init, M);

% Objective Function
objFun = @(U) objectiveFun_safe(U, simulate_glucose, G_star, alpha);

% Lower and Upper Bounds
lb = U_min * ones(N,1);
ub = U_max * ones(N,1);

% Nonlinear Constraints (to enforce glucose safety bounds)
nonlcon = @(U) glucoseBounds_full(U, simulate_glucose, G_min, G_max);

opts = optimoptions('fmincon','Display','iter','Algorithm','sqp','MaxIterations',500);
[U_opt, fval, exitflag, output] = fmincon(objFun, U0, [], [], [], [], lb, ub, nonlcon, opts);

G = simulate_glucose(U_opt);

% Graph Visualizations

figure(1);
plot(0:N, G, '-o', 'LineWidth', 2, 'MarkerSize',4);
hold on;
yline(G_min, '--r', 'LineWidth',1.5);
yline(G_star, '--k', 'LineWidth',1.0);
yline(G_max, '--r', 'LineWidth',1.5);
hold off;
xlabel('Time Step');
ylabel('Glucose (mg/dL)');
title('Glucose Trajectory');
legend('G(k)','G_{min}=70','G_{star}=110','G_{max}=200','Location','best');
grid on;

fprintf('fmincon exitflag = %d\n', exitflag);
fprintf('Minimum glucose in trajectory = %.2f mg/dL\n', min(G));
fprintf('Max glucose in trajectory = %.2f mg/dL\n', max(G));

figure(2);
plot(0:N-1, U_opt, '-o', 'LineWidth', 2, 'MarkerSize', 4);
xlabel('Time Step');
ylabel('Insulin Dose U_k');
title('Optimized Insulin Dosing Sequence');
grid on;

% Function Definitions

function G = simulateG(U, a, b, d, G_init, M)
    N = length(U);
    G = zeros(N+1,1);
    G(1) = G_init;
    for k = 1:N
        Gnext = a*G(k) + b*U(k) + d*M(k);
        G(k+1) = max(0.1, Gnext);
        if isnan(G(k+1)) || isinf(G(k+1))
            G(k+1) = 1e6;
        end
    end
end

function J = objectiveFun_safe(U, simulate_glucose, G_star, alpha)
    try
        J = objectiveFun(U, simulate_glucose, G_star, alpha);
        if ~isfinite(J) || isnan(J)
            J = 1e12;
        end
    catch
        J = 1e12;
    end
end

function J = objectiveFun(U, simulate_glucose, G_star, alpha)
    G = simulate_glucose(U);
    Gk = G(1:end);
    G_min_local = 70;
    hypo_penalty = 1e7 * sum(max(0, G_min_local - Gk).^2);
    devia = sum((Gk - G_star).^2);
    ins_pen = alpha * sum(U.^2);
    J = devia + ins_pen + hypo_penalty;
end

function [c, ceq] = glucoseBounds_full(U, simulate_glucose, G_min, G_max)
    G = simulate_glucose(U);
    G_ineq = G(2:end);
    c = [G_ineq - G_max; G_min - G_ineq];
    ceq = [];
    if any(~isfinite(c))
        c = c + 1e6;
    end
end