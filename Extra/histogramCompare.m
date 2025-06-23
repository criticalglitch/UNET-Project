
training = imread("..\Images\Training\CommSignal3\CommSignal2_vs_CommSignal3_sep_train_0000.sigmf-meta.png");
eval = imread("..\Images\Evaluation\l128s01a01f001c1.png");

% imhist(training);
imhist(eval);

% 
% tiledlayout("horizontal");
% output = figure();
% 
% ax1 = nexttile;
% ax1_pos = ax1.position;
% delete(ax1);
% f2 = figure();
% imhist(training);
% ax1 = copyobj(gca(),f1);
% ax_cs1 = copyobj(findall(f2,'Tag','colorstripe'),f1);
% ax_cs1.Position = [ax1_pos([1 2 3]) ax1_pos(4)*ax_cs1.Position(4)];
% ax1.Position = [ax1_pos(1) ax1_pos(2)+ax_cs1.Position(4) ax1_pos(3) ax1_pos(4)-ax_cs1.Position(4)];
% 
% ax2 = nexttile;
% ax2_pos = ax1.position;
% delete(ax2);
% f3 = figure();
% imhist(eval);
% ax2 = copyobj(gca(),f1);
% ax_cs2 = copyobj(findall(f2,'Tag','colorstripe'),f1);
% ax_cs2.Position = [ax1_pos([1 2 3]) ax1_pos(4)*ax_cs2.Position(4)];
% ax1.Position = [ax2_pos(1) ax2_pos(2)+ax_cs2.Position(4) ax2_pos(3) ax2_pos(4)-ax_cs2.Position(4)];