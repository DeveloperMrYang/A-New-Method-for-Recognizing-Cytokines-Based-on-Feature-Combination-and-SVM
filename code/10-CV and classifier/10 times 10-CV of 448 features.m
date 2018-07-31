for count=1:10
    index=crossvalind('Kfold', 18418, 10);
    for i=1:10
        train_file=['./448/448-',num2str(count),'/','train-',num2str(i),'.libsvm'];
        test_file=['./448/448-',num2str(count),'/','test-',num2str(i),'.libsvm'];
         fid=fopen('448.libsvm');
         fid_test=fopen(test_file,'a');
         fid_train=fopen(train_file,'a');
         num=1;
         while ~feof(fid)
             line=fgetl(fid);
             if index(num)==i
                 fprintf(fid_test,'%s\n',line);
             else
                 fprintf(fid_train,'%s\n',line);
             end
             num=num+1;
         end
         fclose(fid_train);
         fclose(fid_test);
         fclose(fid);
    end
end
