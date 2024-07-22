function mi = mutual_information(hgram)
    hgram = hgram / sum(hgram(:));
    ha = sum(hgram, 2);
    hb = sum(hgram, 1);
    hab = ha * hb;
    hab = hab + (hab == 0); % To prevent division by zero
    mi = sum(hgram(:) .* log2((hgram(:) + (hgram(:) == 0)) ./ hab(:)));
end
