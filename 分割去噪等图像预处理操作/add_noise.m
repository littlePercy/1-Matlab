%% https://ww2.mathworks.cn/help/images/ref/imnoise.html?s_tid=doc_ta#mw_226e1fb2-f53a-4e49-9bb1-6b167fc2eac1
I = imread('Microtubule_original.png');
figure,imshow(I)
%% 向图像添加椒盐噪声，噪声密度为 0.02。显示结果。
J_1 = imnoise(I,'salt & pepper',0.02);
figure,imshow(J_1)
%% 添加高斯白噪声，均值为 m，方差为 var_gauss。
%J_2 = imnoise(I,'gaussian',m,var_gauss) ;
J_2 = imnoise(I, 'gaussian', 0, 0.01) ;
figure,imshow(J_2)
%% 从数据中生成泊松噪声，而不是向数据中添加人为噪声。
% 泊松分布取决于输入图像 I 的数据类型：
% 如果 I 为双精度，则会将输入像素值放大 1e12 倍解释为泊松分布的均值。例如，如果输入像素的值为 5.5e-12，则对应的输出像素将根据均值为 5.5 的泊松分布生成，然后缩小为 1e12 分之一。
% 如果 I 为单精度，则使用的缩放因子是 1e6。
% 如果 I 为 uint8 或 uint16，则直接使用输入像素值，无需缩放。例如，如果 uint8 输入中一个像素的值为 10，则对应的输出像素将根据均值为 10 的泊松分布生成。
J_3 = imnoise(I,'poisson');
figure,imshow(J_3)
%% 使用方程 J = I+n*I 添加乘性噪声
%J_4 = imnoise(I,'speckle'); %均值为 0、方差为 0.05 的均匀分布随机噪声。
J_4 = imnoise(I,'speckle',0.1); %添加方差为 var_speckle 的乘性噪声。
figure,imshow(J_4)
