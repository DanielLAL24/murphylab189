function demprgp(action);
%DEMPRGP Demonstrate sampling from a Gaussian Process prior.
%
%	Description
%	This function plots the functions represented by a Gaussian Process
%	model. The hyperparameter values can be adjusted  on a linear scale
%	using the sliders (though the exponential of the parameters is used
%	in the covariance function), or  by typing values into the text boxes
%	and pressing the return key. Both types of covariance function are
%	supported.  An extra function specific parameter is needed for the
%	rational quadratic function.
%
%	See also
%	GP
%

%	Copyright (c) Ian T Nabney (1996-2001)

if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize')

  % Bounds on hyperparameter values
  biasminval = -3.0; biasmaxval = 3.0;
  noiseminval = -20; noisemaxval = -2;
  fparminval = 0.0; fparmaxval = 2.0;
  inwminval = 0; inwmaxval = 8;
  % Initial hyperparameter values
  bias = (biasminval+biasmaxval)/2;
  noise = (noiseminval+noisemaxval)/2;
  inweights = (inwminval+inwmaxval)/2;
  fpar = (fparminval+fparmaxval)/2;
  fpar2 = (fparminval+fparmaxval)/2;
  
  gptype = 'sqexp';
  
  % Create FIGURE
  fig=figure( ...
    'Name','Sampling from a Gaussian Process prior', ...
    'Position', [50 50 480 380], ...
    'NumberTitle','off', ...
    'Color', [0.8 0.8 0.8], ...
    'Visible','on');

  % List box for covariance function type
  nettype_box = uicontrol(fig, ...
    'Style', 'listbox', ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'center', ...
    'Position', [0.52 0.77 0.40 0.12], ...
    'String', 'Squared Exponential|Rational Quadratic', ...
    'Max', 1, 'Min', 0, ... % Only allow one selection
    'Value', 1, ... % Initial value is squared exponential
    'BackgroundColor',[0.60 0.60 0.60],...
    'CallBack', 'demprgp GPtype');

  % Title for list box
  uicontrol(fig, ...
    'Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0.52 0.89 0.40 0.05], ...
    'String', 'Covariance Function Type', ...
    'BackgroundColor', get(fig, 'Color'), ...
    'HorizontalAlignment', 'center');
  
  % Frames to enclose sliders
  bottom_row = 0.04;
  slider_frame_height = 0.15;
  biasframe = uicontrol(fig, ...
    'Style', 'frame', ...
    'Units', 'normalized', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'String', 'bias', ...
    'HorizontalAlignment', 'left', ...
    'Position', [0.05 bottom_row 0.35 slider_frame_height]);
  
  bpos = get(biasframe, 'Position');
  noise_frame_bottom = bpos(2) + bpos(4) + 0.02;
  noiseframe = uicontrol(fig, ...
    'Style', 'frame', ...
    'Units', 'normalized', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position', [0.05 noise_frame_bottom 0.35 slider_frame_height]);
   
  npos = get(noiseframe, 'Position');
  inw_frame_bottom = npos(2) + npos(4) + 0.02;
  inwframe = uicontrol(fig, ...
    'Style', 'frame', ...
    'Units', 'normalized', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position', [0.05 inw_frame_bottom 0.35 slider_frame_height]);
   
  inwpos = get(inwframe, 'Position');
  fpar_frame_bottom = inwpos(2) + inwpos(4) + 0.02;
  % This frame sometimes has multiple parameters
  uicontrol(fig, ...
    'Style', 'frame', ...
    'Units', 'normalized', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position', [0.05 fpar_frame_bottom 0.35 2*slider_frame_height]);
   
  % Frame text
  slider_text_height = 0.05;
  slider_text_voffset = 0.08;
  uicontrol(fig, ...
    'Style', 'text', ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position', [0.07 bottom_row+slider_text_voffset ...
      0.06 slider_text_height], ...
    'String', 'bias');

  % Frame text
  noiseframe = uicontrol(fig, ...
    'Style', 'text', ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position', [0.07 noise_frame_bottom+slider_text_voffset ...
      0.08 slider_text_height], ...
    'String', 'noise');

  % Frame text
  uicontrol(fig, ...
    'Style', 'text', ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position', [0.07 inw_frame_bottom+slider_text_voffset ...
      0.14 slider_text_height], ...
    'String', 'inweights');

  % Frame text
  uicontrol(fig, ...
    'Style', 'text', ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position', [0.07 fpar_frame_bottom+slider_frame_height+ ...
       slider_text_voffset 0.06 slider_text_height], ...
    'String', 'fpar');

 uicontrol(fig, ...
    'Style', 'text', ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position', [0.07 fpar_frame_bottom+slider_text_voffset ...
       0.06 slider_text_height], ...
    'String', 'fpar2', ...
    'Tag', 'fpar2text', ...
    'Enable', 'off');
   
  % Slider
  slider_left = 0.07;
  slider_width = 0.31;
  slider_frame_voffset = 0.02;
  biasslide = uicontrol(fig, ...
    'Style', 'slider', ...
    'Units', 'normalized', ...
    'Value', bias, ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [slider_left bottom_row+slider_frame_voffset ...
      slider_width 0.05], ...
    'Min', biasminval, 'Max', biasmaxval, ...
    'Callback', 'demprgp update');
  
  % Slider
  noiseslide = uicontrol(fig, ...
    'Style', 'slider', ...
    'Units', 'normalized', ...
    'Value', noise, ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [slider_left noise_frame_bottom+slider_frame_voffset ...
      slider_width 0.05], ...
    'Min', noiseminval, 'Max', noisemaxval, ...
    'Callback', 'demprgp update');
  
  % Slider
  inweightsslide = uicontrol(fig, ...
    'Style', 'slider', ...
    'Units', 'normalized', ...
    'Value', inweights, ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [slider_left inw_frame_bottom+slider_frame_voffset ...
      slider_width 0.05], ...
    'Min', inwminval, 'Max', inwmaxval, ...
    'Callback', 'demprgp update');
  
  % Slider
  fparslide = uicontrol(fig, ...
    'Style', 'slider', ...
    'Units', 'normalized', ...
    'Value', fpar, ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [slider_left fpar_frame_bottom+slider_frame_height+ ...
       slider_frame_voffset slider_width 0.05], ...
    'Min', fparminval, 'Max', fparmaxval, ...
    'Callback', 'demprgp update');
 
 fpar2slide = uicontrol(fig, ...
    'Style', 'slider', ...
    'Units', 'normalized', ...
    'Value', fpar2, ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [slider_left fpar_frame_bottom+slider_frame_voffset ...
       slider_width 0.05], ...
    'Min', fparminval, 'Max', fparmaxval, ...
    'Callback', 'demprgp update', ...
    'Tag', 'fpar2slider', ...
    'Enable', 'off');
  
  % Text display of hyper-parameter values
  
  format = '%8f';

  hp_left = 0.20;
  hp_width = 0.17;
  biasval = uicontrol(fig, ...
    'Style', 'edit', ...
    'Units', 'normalized', ...
    'Position', [hp_left bottom_row+slider_text_voffset ...
      hp_width slider_text_height], ...
    'String', sprintf(format, bias), ...
    'Callback', 'demprgp newval');
  
  noiseval = uicontrol(fig, ...
    'Style', 'edit', ...
    'Units', 'normalized', ...
    'Position', [hp_left noise_frame_bottom+slider_text_voffset ...
      hp_width slider_text_height], ...
    'String', sprintf(format, noise), ...
    'Callback', 'demprgp newval');
  
  inweightsval = uicontrol(fig, ...
    'Style', 'edit', ...
    'Units', 'normalized', ...
    'Position', [hp_left inw_frame_bottom+slider_text_voffset ...
      hp_width slider_text_height], ...
    'String', sprintf(format, inweights), ...
    'Callback', 'demprgp newval');
  
  fparval = uicontrol(fig, ...
    'Style', 'edit', ...
    'Units', 'normalized', ...
    'Position', [hp_left fpar_frame_bottom+slider_frame_height+ ...
       slider_text_voffset hp_width slider_text_height], ...
    'String', sprintf(format, fpar), ...
    'Callback', 'demprgp newval');
 
  fpar2val = uicontrol(fig, ...
    'Style', 'edit', ...
    'Units', 'normalized', ...
    'Position', [hp_left fpar_frame_bottom+slider_text_voffset ...
       hp_width slider_text_height], ...
    'String', sprintf(format, fpar), ...
    'Callback', 'demprgp newval', ...
    'Enable', 'off', ...
    'Tag', 'fpar2val');
   
  
  % The graph box
  haxes = axes('Position', [0.5 0.28 0.45 0.45], ...
    'Units', 'normalized', ...
    'Visible', 'on');

  % The SAMPLE button
  uicontrol(fig, ...
    'Style','push', ...
    'Units','normalized', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position',[0.5 bottom_row 0.13 0.1], ...
    'String','Sample', ...
    'Callback','demprgp replot');
  
  % The CLOSE button
  uicontrol(fig, ...
    'Style','push', ...
    'Units','normalized', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position',[0.82 bottom_row 0.13 0.1], ...
    'String','Close', ...
    'Callback','close(gcf)');
  
  % The HELP button
  uicontrol(fig, ...
    'Style','push', ...
    'Units','normalized', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position',[0.66 bottom_row 0.13 0.1], ...
    'String','Help', ...
    'Callback','demprgp help');
  
   % Save handles to objects
  
   hndlList=[fig biasslide noiseslide inweightsslide fparslide ...
         biasval noiseval inweightsval ...
      fparval haxes nettype_box];
  set(fig, 'UserData', hndlList);
  
  demprgp('replot')
  
  
elseif strcmp(action, 'update'),
  
  % Update when a slider is moved.
  
  hndlList   = get(gcf, 'UserData');
  biasslide   = hndlList(2);
  noiseslide = hndlList(3);
  inweightsslide  = hndlList(4);
  fparslide = hndlList(5);
  biasval = hndlList(6);
  noiseval = hndlList(7);
  inweightsval = hndlList(8);
  fparval = hndlList(9);
  haxes = hndlList(10);
  nettype_box = hndlList(11);

  
  bias = get(biasslide, 'Value');
  noise = get(noiseslide, 'Value');
  inweights = get(inweightsslide, 'Value');
  fpar = get(fparslide, 'Value');
  fpar2 = get(findobj('Tag', 'fpar2slider'), 'Value');
    
  format = '%8f';
  set(biasval, 'String', sprintf(format, bias));
  set(noiseval, 'String', sprintf(format, noise));
  set(inweightsval, 'String', sprintf(format, inweights));
  set(fparval, 'String', sprintf(format, fpar));
  set(findobj('Tag', 'fpar2val'), 'String', ...
     sprintf(format, fpar2));
  
  demprgp('replot');
  
elseif strcmp(action, 'newval'),
  
  % Update when text is changed.
  
  hndlList   = get(gcf, 'UserData');
  biasslide   = hndlList(2);
  noiseslide = hndlList(3);
  inweightsslide  = hndlList(4);
  fparslide = hndlList(5);
  biasval = hndlList(6);
  noiseval = hndlList(7);
  inweightsval = hndlList(8);
  fparval = hndlList(9);
  haxes = hndlList(10);
    
  bias = sscanf(get(biasval, 'String'), '%f');
  noise = sscanf(get(noiseval, 'String'), '%f');
  inweights = sscanf(get(inweightsval, 'String'), '%f');
  fpar = sscanf(get(fparval, 'String'), '%f');
  fpar2 = sscanf(get(findobj('Tag', 'fpar2val'), 'String'), '%f');
  
  set(biasslide, 'Value', bias);
  set(noiseslide, 'Value', noise);
  set(inweightsslide, 'Value', inweights);
  set(fparslide, 'Value', fpar);
  set(findobj('Tag', 'fpar2slider'), 'Value', fpar2);
  
  demprgp('replot');
  
elseif strcmp(action, 'GPtype')
  hndlList   = get(gcf, 'UserData');
  nettype_box = hndlList(11);
  gptval = get(nettype_box, 'Value');
  if gptval == 1
     % Squared exponential, so turn off fpar2
     set(findobj('Tag', 'fpar2text'), 'Enable', 'off');
     set(findobj('Tag', 'fpar2slider'), 'Enable', 'off');
     set(findobj('Tag', 'fpar2val'), 'Enable', 'off');
  else
     % Rational quadratic, so turn on fpar2
     set(findobj('Tag', 'fpar2text'), 'Enable', 'on');
     set(findobj('Tag', 'fpar2slider'), 'Enable', 'on');
     set(findobj('Tag', 'fpar2val'), 'Enable', 'on');
  end
  demprgp('replot');
  
elseif strcmp(action, 'replot'),
  
  % Re-sample from the prior and plot graphs.
 
  oldFigNumber=watchon;

  hndlList   = get(gcf, 'UserData');
  biasslide   = hndlList(2);
  noiseslide = hndlList(3);
  inweightsslide  = hndlList(4);
  fparslide = hndlList(5);
  haxes = hndlList(10);
  nettype_box = hndlList(11);
  gptval = get(nettype_box, 'Value');
  if gptval == 1
    gptype = 'sqexp';
  else
    gptype = 'ratquad';
  end
  
  bias = get(biasslide, 'Value');
  noise = get(noiseslide, 'Value');
  inweights = get(inweightsslide, 'Value');
  fpar = get(fparslide, 'Value');
  
 
  axes(haxes);
  cla
  set(gca, ...
    'Box', 'on', ...
    'Color', [0 0 0], ...
    'XColor', [0 0 0], ...
    'YColor', [0 0 0], ...
    'FontSize', 14);
  ymin = -10;
  ymax = 10;
  axis([-1 1 ymin ymax]);  
  set(gca,'DefaultLineLineWidth', 2);

  xvals = (-1:0.01:1)';
  nsample = 10;    % Number of samples from prior.
  hold on
  plot([-1 0; 1 0], [0 ymin; 0 ymax], 'b--');
  net = gp(1, gptype);
  net.bias = bias;
  net.noise = noise;
  net.inweights = inweights;
  if strcmp(gptype, 'sqexp')
    net.fpar = fpar;
  else
    fpar2 = get(findobj('Tag', 'fpar2slider'), 'Value');
    net.fpar = [fpar fpar2];
  end
  cn = gpcovar(net, xvals);
  cninv = inv(cn);
  cnchol = chol(cn);
  set(gca, 'DefaultLineLineWidth', 1);
  for n = 1:nsample
    y = (cnchol') * randn(size(xvals));
    plot(xvals, y, 'y');
  end
 
  watchoff(oldFigNumber);
 
elseif strcmp(action, 'help'),
  
  % Provide help to user.

  oldFigNumber=watchon;

  helpfig = figure('Position', [100 100 480 400], ...
    'Name', 'Help', ...
    'NumberTitle', 'off', ...
    'Color', [0.8 0.8 0.8], ...
    'Visible','on');
  
    % The HELP TITLE BAR frame
  uicontrol(helpfig,  ...
    'Style','frame', ...
    'Units','normalized', ...
    'HorizontalAlignment', 'center', ...
    'Position', [0.05 0.82 0.9 0.1], ...
    'BackgroundColor',[0.60 0.60 0.60]);
  
  % The HELP TITLE BAR text
  uicontrol(helpfig, ...
    'Style', 'text', ...
    'Units', 'normalized', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position', [0.26 0.85 0.6 0.05], ...
    'HorizontalAlignment', 'left', ...
    'String', 'Help: Sampling from a Gaussian Process Prior');
  
  helpstr1 = strcat(...
    'This demonstration shows the effects of sampling from a Gaussian', ...
     ' process prior. The parameters bias, noise, inweights and fpar', ...
     ' control the corresponding terms in the covariance function of the',...
     ' Gaussian process. Their values can be adjusted on a linear scale',...
     ' using the sliders, or by typing values into the text boxes and',...
     ' pressing the return key.  After setting these values, press the',...
     ' ''Sample'' button to see a new sample from the prior.');

   helpstr2 = strcat(...
      'Observe how inweights controls horizontal length-scale of the',...
       ' variation in the functions, noise controls the roughness of the',...
       ' functions, and the bias controls the size of the', ...
       ' vertical offset of the signal.');
   helpstr3 = strcat(...
       'There are two types of covariance function supported by', ...
       ' Netlab which can be selected using the ''Covariance Function', ...
       ' Type'' menu.');
   helpstr4 = strcat(...
       'The squared exponential has a single fpar which', ...
       ' controls the vertical scale of the process.');
   helpstr5 = strcat(...
      'The rational quadratic has two fpar values.  The first is', ...
      ' is a scale parameter inside the rational function like the',...
      ' first fpar for the squared exponential covariance, while the', ...
      ' second gives the exponent of the rational function (i.e. the',...
      ' rate of decay of the covariance function.');
   % Set up cell array with help strings
   hstr(1) = {helpstr1};
   hstr(2) = {''};
   hstr(3) = {helpstr2};
   hstr(4) = {''};
   hstr(5) = {helpstr3};
   hstr(6) = {''};
   hstr(7) = {helpstr4};
   hstr(8) = {''};
   hstr(9) = {helpstr5};

  % The HELP text
  helpui = uicontrol(helpfig, ...
    'Style', 'Text', ...
    'Units', 'normalized', ...
    'ForegroundColor', [0 0 0], ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [1 1 1], ...
    'Min', 0, ...
    'Max', 2, ...
    'Position', [0.05 0.2 0.9 0.57]);
  [hstrw, newpos] = textwrap(helpui, hstr);
  set(helpui, 'String', hstrw, 'Position', [0.05, 0.2, 0.9 newpos(4)]);
	     
  % The CLOSE button
  uicontrol(helpfig, ...
    'Style','push', ...
    'Units','normalized', ...
    'BackgroundColor', [0.6 0.6 0.6], ...
    'Position',[0.4 0.05 0.2 0.1], ...
    'String','Close', ...
    'Callback','close(gcf)');

   watchoff(oldFigNumber);

end;

