function segimage = active3Dsegment(image,startsliceno,stopsliceno)

segimage = logical(zeros(size(image)));
for I = startsliceno:stopsliceno
        segimage(:,:,I) = activcon_seg(image(:,:,I));
end

