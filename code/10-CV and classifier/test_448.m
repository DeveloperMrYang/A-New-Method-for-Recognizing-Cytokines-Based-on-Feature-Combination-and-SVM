TP=zeros(100,1);
FP=zeros(100,1);
TN=zeros(100,1);
FN=zeros(100,1);
accuracy=zeros(100,1);
for m=1:10
    k=(m-1)*10;
    for i=1:10
        train_file=['./448/448-',num2str(m),'/train-',num2str(i),'.libsvm'];
        test_file=['./448/448-',num2str(m),'/test-',num2str(i),'.libsvm'];
        [train_label,train]=libsvmread(train_file);
        [test_label,test]=libsvmread(test_file);
        cmd=['-t 2',' -c ',num2str(4),' -g ',num2str(0.0313)];
        model_3=libsvmtrain(train_label,train,cmd);
        [P,A,D]=libsvmpredict(test_label,test,model_3);
        accuracy(k+i)=A(1);
        predict_label=P;
        len=size(test_label,1);
        for j=1:1:len
            if test_label(j)==0&&predict_label(j)==0
                TP(k+i)=TP(k+i)+1;
            elseif test_label(j)==0&&predict_label(j)==1
                FN(k+i)=FN(k+i)+1;
            elseif test_label(j)==1&&predict_label(j)==0
                FP(k+i)=FP(k+i)+1;
            elseif test_label(j)==1&&predict_label(j)==1
                TN(k+i)=TN(k+i)+1;
            end
        end
    end
end