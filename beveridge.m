% Dynare-től kapott százalékos eltérések
u_hat = oo_.endo_simul(strmatch('u_hat', M_.endo_names, 'exact'), :);
ur_hat = oo_.endo_simul(strmatch('ur_hat', M_.endo_names, 'exact'), :);
uf_hat = oo_.endo_simul(strmatch('uf_hat', M_.endo_names, 'exact'), :);

% Helyes historikus szétválasztás (abszolút szintek)
u_total = u_ss*(1 + u_hat);
ur_total = ur_ss*(1 + ur_hat);
uf_total = uf_ss*(1 + uf_hat);

% Ellenőrzés (ur_total + uf_total ≈ u_total)
check_sum = ur_total + uf_total;

% Ellenőrzés, hogy vannak-e negatív értékek
disp(['Negatív értékek száma ur-ben: ', num2str(sum(ur_total<0))]);
disp(['Negatív értékek száma uf-ben: ', num2str(sum(uf_total<0))]);

% Plot
figure;
hold on;
area(ur_total', 'FaceColor', [0.9 0.3 0.2]);
area(uf_total', 'FaceColor', [0.2 0.6 0.9]);
title('Historikus szétválasztás: Frictional vs. Rationing munkanélküliség');
xlabel('Időperiódus');
ylabel('Munkanélküliségi ráta');
legend('Rationing (Adagolásos)', 'Frictional (Súrlódásos)');
grid on;
hold off;
