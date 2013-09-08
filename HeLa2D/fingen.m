function fin = fingen(errorTable2)

errorTable2(find(errorTable2(:,2)==0),:) = [];

num_err = 100*mean(abs((errorTable2(:,2)-errorTable2(:,6))./errorTable2(:,6)));
mu_err = 100*mean(abs((errorTable2(:,3)-errorTable2(:,7))./errorTable2(:,7)));
std_err = 100*mean(abs((errorTable2(:,4)-errorTable2(:,8))./errorTable2(:,8)));
colli_err = 100*mean(abs((errorTable2(:,5)-errorTable2(:,9))./errorTable2(:,9)));
fin = [num_err, mu_err, std_err, colli_err];

end
