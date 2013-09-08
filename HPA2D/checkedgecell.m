function ed = checkedgecell(mask)


if sum(mask(:)) == 0
        ed = 0;
        ed = logical(ed);
        return;
end

mask = double(mask);
a = size(mask);

coHor = find((conv(double(sum(mask,1)~=0),[1 1])) == 1);
coVer = find((conv(double(sum(mask,2)~=0)',[1 1])) == 1);

ed= (coHor(1) == 1) || ((coHor(2)-1) == a(2)) || (coVer(1) == 1) || ((coVer(2)-1) == a(1));
