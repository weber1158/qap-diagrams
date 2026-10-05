%
% This script generates the repository's thumbnail image.
%

clear,clc

A=[20;15;13;10];
Q=[30;35;29;49];
P=[50;50;53;41];

red = [0.89 0 0];
green = [0.01 0.62 0.30];
blue = [0.01 0.26 0.87];

clf
figure(1)
H = qap_diagram(VertexLabels='on',FontColor=[0.25 0.25 0.25]);
ternplot(A,P,Q,'kd','MarkerFaceColor',red,'MarkerSize',9);

% Plot again in a different order for visualization purposes only.
% In a real QAP use case, always use ternplot(A,P,Q) and never another
% combination.
ternplot(Q,A,P,'ko','MarkerFaceColor',green,'MarkerSize',9);
ternplot(P,Q,A,'k^','MarkerFaceColor',blue,'MarkerSize',9);

[H.TickLabels.Visible] = deal('off');

H.RockTypes.Granite.Color = green;
H.RockTypes.Granodiorite.Color = red;
H.RockTypes.QuartzMonzonite.Color = blue;

legend('Site A',...
       'Site B',...
       'Site C',...
       'FontSize',12)

% Copyright 2026 Austin M. Weber