function classification = qap_classification(Q,A,P)
%Igneous rock classification
%
%DESCRIPTION
% Classifies plutonic and volcanic igneous rocks based on the relative
% abundance of quartz (Q), alkali feldspar (A), and plagioclase (P).
% 
%
%SYNTAX
% qap_classification(Q,A,P)
% classification = qap_classification(Q,A,P)
%
%
%INPUTS
% Q {1×1 double}: Number of quartz grains or the abundance of quartz
%                 relative to the sum of quartz, alkali feldspar, and
%                 plagioclase feldspar.
%
% A {1×1 double}: Number of alkali feldspar grains or the abundance of
%                 alkali feldspar relative to the sum of Q, A, and P.
%
% P {1×1 double}: Number of plagioclase grains or the abundance of
%                 plagioclase relative to the sum of Q, A, and P.
%
%
%OUTPUT
% classification {1×1 struct}: Object containing the plutonic and volcanic
%                              igneous rock class for the given Q-A-P data
%
%
%EXAMPLE
% num_Q = 33;
% num_A = 15;
% num_P = 52;
% C = qap_classification(num_Q, num_A, num_P);
% fprintf('The plutonic (volcanic) identity of the sample is: %s (%s)\n',...
%   C.Plutonic, C.Volcanic)
%

arguments (Input)
  Q (1,1) double {mustBeNonnegative}
  A (1,1) double {mustBeNonnegative}
  P (1,1) double {mustBeNonnegative}
end

arguments (Output)
  classification (1,1) struct
end

% Normalize data so that it sums to 100%
total = Q + A + P;
if total == 0
  error('Q, A, and P cannot all be zero!')
end
Q = Q / total;
A = A / total;
P = P / total;

% Evaluate feldspar ratio
P_AP = P / (A+P);

% Determine final classification
if Q >= 0.9
  classification = Q_90();
elseif Q >= 0.6
  classification = Q_60_90();
elseif Q >= 0.2
  classification = Q_20_60(P_AP);
elseif Q >= 0.05
  classification = Q_5_20(P_AP);
else
  classification = Q_0_5(P_AP);
end

%
% END MAIN FUNCTION
%
end

%
% LOCAL FUNCTIONS
%
function C = define_igneous_class(key)
%Define the output class
  % Create a dictionary for plutonic/volcanic equivalents
  persistent igneous_class
  if isempty(igneous_class)
    igneous_class = dictionary('quartzolite','n/a',...
      'quartz-rich granitoid','n/a',...
        'alkali feldspar granite','alkali feldspar rhyolite',...
        'granite1','rhyolite',...
        'granite2','rhyodacite',...
        'granodiorite','dacite',...
        'tonalite','quartz andesite',...
      'quartz alkali feldspar syenite','trachyte',...
      'quartz syenite','trachyte',...
      'quartz monzonite','latite',...
      'quartz monzodiorite','andesite',...
      'quartz diorite/quartz gabbro','quartz andesite',...
        'alkali feldspar syenite','trachyte',...
        'syenite','trachyte',...
        'monzonite','latite',...
        'monzodiorite','andesite',...
        'diorite/gabbro','basalt');
  end

  if strcmpi(key,'granite1') || strcmpi(key,'granite2')
    C.Plutonic = 'granite';
  else
    C.Plutonic = char(key);
  end
  C.Volcanic = char(igneous_class(key));
end

function C = Q_90()
%If Q>=90%
  C = define_igneous_class('quartzolite');
end

function C = Q_60_90()
%If 60% <= Q < 90%
  C = define_igneous_class('quartz-rich granitoid');
end

function C = Q_20_60(feldspar_ratio)
%If 20% <= Q < 60%
  if feldspar_ratio < 0.1
    C = define_igneous_class('alkali feldspar granite');
  elseif feldspar_ratio <= 0.35
    C = define_igneous_class('granite1');
  elseif feldspar_ratio <= 0.65
    C = define_igneous_class('grainite2');
  elseif feldspar_ratio <= 0.9
    C = define_igneous_class('granodiorite');
  elseif feldspar_ratio > 0.9
    C = define_igneous_class('tonalite');
  else
    error('Feldspar ratio (P/(A+P)) does not fall in the range 0-1!')
  end
end

function C = Q_5_20(feldspar_ratio)
%If 5% <= Q < 20%
  if feldspar_ratio < 0.1
    C = define_igneous_class('quartz alkali feldspar syenite');
  elseif feldspar_ratio <= 0.35
    C = define_igneous_class('quartz syenite');
  elseif feldspar_ratio <= 0.65
    C = define_igneous_class('quartz monzonite');
  elseif feldspar_ratio <= 0.9
    C = define_igneous_class('quartz monzodiorite');
  elseif feldspar_ratio > 0.9
    C = define_igneous_class('quartz diorite/quartz gabbro');
  else
    error('Feldspar ratio (P/(A+P)) does not fall in the range 0-1!')
  end
end

function C = Q_0_5(feldspar_ratio)
%If Q < 5%
  if feldspar_ratio < 0.1
    C = define_igneous_class('alkali feldspar syenite');
  elseif feldspar_ratio <= 0.35
    C = define_igneous_class('syenite');
  elseif feldspar_ratio <= 0.65
    C = define_igneous_class('monzonite');
  elseif feldspar_ratio <= 0.9
    C = define_igneous_class('monzodiorite');
  elseif feldspar_ratio > 0.9
    C = define_igneous_class('diorite/gabbro');
  else
    error('Feldspar ratio (P/(A+P)) does not fall in the range 0-1!')
  end
end
