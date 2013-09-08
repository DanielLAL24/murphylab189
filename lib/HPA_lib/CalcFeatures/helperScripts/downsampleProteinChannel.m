
tmp_size = size(protstruct.channel);

if DSF==2
    if isempty(protstruct.downsampled2x)
        protstruct.downsampled2x = imresize(protstruct.channel,[tmp_size(1) tmp_size(2)]/DSF);
    end
end

if DSF==4
    if isempty(protstruct.downsampled4x)
        protstruct.downsampled4x = imresize(protstruct.channel,[tmp_size(1) tmp_size(2)]/DSF);
    end
end
