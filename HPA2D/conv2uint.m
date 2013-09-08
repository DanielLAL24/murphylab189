function outpt = conv2uint(input_image)

input_image = input_image - min(input_image(:));
input_image = double(input_image) / double(max(input_image(:)));
input_image = uint8(round(255*input_image));

outpt = input_image;

end
