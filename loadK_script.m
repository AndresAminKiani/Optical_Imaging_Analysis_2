% [Kon, Koff, trON, trOFF, ~, ~, ~] = loadK();
% [Kon_2, Koff_2, trON_2, trOFF_2, ~, ~, ~] = loadK_2();
% [Kon_3, Koff_3, trON_3, trOFF_3, ~, ~, ~] = loadK_3();
% 
% [nm_A, om_A, eNT, eOT] = meanMethod2a(Kon);
% Knm_on = meanMethod2b(nm_A, om_A, eNT, eOT, 2 : 15);
% clear Kon nm_A om_A eNT eOT
% 
% [nm_A, om_A, eNT, eOT] = meanMethod2a(Koff);
% Knm_off = meanMethod2b(nm_A, om_A, eNT, eOT, 2 : 15);
% clear Koff nm_A om_A eNT eOT
% 
% [nm_A, om_A, eNT, eOT] = meanMethod2a(Kon_2);
% Knm_on2 = meanMethod2b(nm_A, om_A, eNT, eOT, 2 : 20);
% clear Kon_2 nm_A om_A eNT eOT
% 
% [nm_A, om_A, eNT, eOT] = meanMethod2a(Koff_2);
% Knm_off2 = meanMethod2b(nm_A, om_A, eNT, eOT, 2 : 20);
% clear Koff_2 nm_A om_A eNT eOT
% 
[nm_A, om_A, eNT, eOT] = meanMethod2a(Kon_3);
Knm_on3 = meanMethod2b(nm_A, om_A, eNT, eOT, 2 : 20);
clear Kon_3 nm_A om_A eNT eOT

[nm_A, om_A, eNT, eOT] = meanMethod2a(Koff_3);
Knm_off3 = meanMethod2b(nm_A, om_A, eNT, eOT, 2 : 20);
clear Koff_3 nm_A om_A eNT eOT

%%
save('nmK_K2_K3.mat', 'Knm_on', 'Knm_off',...
                                         'Knm_on2', 'Knm_off2',...
                                         'Knm_on3', 'Knm_off3',...
                                         'trON', 'trOFF', 'trON_2', 'trOFF_2', 'trON_3', 'trOFF_3');

