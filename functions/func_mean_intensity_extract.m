function outputArg1 = func_mean_intensity_extract(inputArg1)
[r,c] = find(inputArg1~=0);
intensity_list = [];
for i = 1:length(r)
    temp = inputArg1(r(i),c(i));
    intensity_list = [intensity_list; temp];
end
outputArg1 = sum(intensity_list)/length(intensity_list);


