// Endogenous variables

var n_hat, u_hat, h_hat, y_hat, theta_hat, w_hat, a_hat, cons_hat ur_hat, uf_hat ;

// Exogenous variables
varexo   z;

// Parameters
parameters alpha delta s gamma omega rho eta mu c u_ss s_1 s_2 s_3 theta_ss a_ss n_ss h_ss y_ss w_ss cons_ss ur_ss  uf_ss;

delta = 0.99; // discont rate
s = 0.015656861; // job separation rate
mu = 0.45062;    // efficiancy of matching
eta = 0.65546;    // unemployment-elascticity of matching
gamma = 0.7;   // real wage flexibility MARADT 
c = 0.1833592;    // recruiting cost
alpha = 0.678; // marginal returns to labor
omega = 0.5729974; // steady-state real wage
rho = 0.96;   // autocorrelation of technology
sigma = 0.000406276513 ;   // standard deviation of schocks

// Steady state model
steady_state_model;
    theta_ss = 1;
    u_ss = s / (s + (1 - s) * (mu*theta_ss^eta));
    n_ss = (1 - u_ss) / (1 - s);
    h_ss = s * n_ss;
    a_ss = 1;
    y_ss = a_ss * n_ss^alpha;
    w_ss = omega;
    s_2 = w_ss/(alpha * a_ss) * n_ss^(1 - alpha);
    s_3 = c/(mu*theta_ss^(eta-1)) * 1 / alpha * n_ss^(1 - alpha);
    w_ss= alpha * n_ss^(alpha - 1)   - (1 - delta * (1 - s)) * c * a_ss / (mu * theta_ss^(eta - 1));
    cons_ss = y_ss - c*a_ss/(mu * theta_ss^(eta - 1))*h_ss;
    s_1 = c/(mu * theta_ss^(eta - 1))*s*n_ss^(1-eta);
     ur_ss=1-(alpha/omega)^1/(1-alpha);
    uf_ss=u_ss-ur_ss;

end;
// model equations
model ;

  // Definition of labor market tightness
    (1 - eta) * theta_hat = h_hat - u_hat(-1);
    
    // Definition of unemployment
    u_hat + (1 - steady_state(u_ss)) / steady_state(u_ss) * n_hat(-1) = 0;
    
    // Law of motion of employment
    n_hat = (1 - s) * n_hat(-1) + s * h_hat;
    
    // Production constraint
    y_hat = a_hat + alpha * n_hat;
    y_hat = (1 - steady_state(s_1)) * cons_hat + steady_state(s_1) * (h_hat + eta * theta_hat + a_hat);
    
    // Wage rule
    w_hat = gamma * a_hat;
    
    // Firm's optimality condition
    -a_hat + (1 - alpha) * n_hat + steady_state(s_2) * w_hat + steady_state(s_3) * (eta * theta_hat + a_hat) + (1 - steady_state(s_2) - steady_state(s_3)) * (eta * theta_hat(+1) + a_hat(+1)) = 0;
    
    // Technology shock
    a_hat = rho * a_hat(-1) - z;

   // ur_hat = log(1 + exp(- ((1-gamma)/(1-alpha)) * ((1-uf_ss)/uf_ss) * a_hat(-1)));
    ur_hat =  ((1-gamma)/(1-alpha)) * ((1-ur_ss)/ur_ss)*a_hat(-1);
//  ur_hat = max(0, - ((1-gamma)/(1-alpha))*((1-ur_ss)/ur_ss)*a_hat(-1));
// u_hat = max(0, ((u_ss - ur_ss) / u_ss) * uf_hat + (ur_ss / u_ss) * ur_hat);
u_hat=((u_ss-ur_ss)/u_ss)*uf_hat - (ur_ss/u_ss)*ur_hat;
 // uf_hat=u_hat-ur_hat;
  // ur_hat = max(0.001, 1 - ((alpha / omega)^(1 / (1 - alpha))) * a_hat(-1)^((1 - gamma) / (1 - alpha)));


  //  uf_hat = u_hat - ur_hat;
    
end;






// initvals
initval;
    n_hat = 0;   
   theta_hat = 0; 
    w_hat = 0;    
    a_hat =0;           
    u_hat = 0;
    y_hat =0 ;
    h_hat = 0 ;
    cons_hat = 0;
   uf_hat=0;
    ur_hat=0;
end;

resid(1);
steady;
check;

shocks;
   var z = sigma;
    
  
    
end;

// Simulations
stoch_simul(order=1, irf=20, periods=200);






% Szimuláció eredményeinek kinyerése (log-lineáris eltérések)
u_hat_series = oo_.endo_simul(strmatch('u_hat',M_.endo_names,'exact'),:);

% Steady-state munkanélküliségi ráta kiszámítása a modell alapján
u_ss = s / (s + (1 - s) * (mu * theta_ss^eta));  % Ugyanaz, mint a steady_state_model blokkban

% Visszaalakítás normál munkanélküliségi értékre
u_series = u_hat_series * u_ss + u_ss;

% Ábra készítése a normál munkanélküliségi rátáról
figure;
plot(u_series);
title('Simulated Unemployment Rate (Actual Values) Over Time');
xlabel('Periods');
ylabel('Unemployment Rate');
grid on;

% Eredmény mentése ábraként
saveas(gcf, 'simulated_unemployment_rate_actual.png');
