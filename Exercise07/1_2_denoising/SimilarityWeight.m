function [similarity] = SimilarityWeight(patch1,patch2,sigma)
    similarity = 0;
    
    
    for i=1:min(size(patch1,1), size(patch2,1))
        for j=1:min(size(patch1,2), size(patch2,2))
            similarity = similarity + exp(-(abs(patch1(i,j)-patch2(i,j)))^2/(2*sigma^2));
        end
    end
end