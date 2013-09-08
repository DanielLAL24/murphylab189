function script_loadimage_script(setno,fieldnos,dataloc1,dataloc2)

for thr = 6:8
	for fieldno = fieldnos
		script_loadimage(setno,fieldno,thr,dataloc1,dataloc2);
	end
end
