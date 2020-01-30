list_file1="listfile1.txt"
echo "" > $list_file1
for i in a b c d e f g h i j k l m n o p q r s t u v w x y z
do
    curl https://www.nasdaq.com/glossary/$i | sed -ne '/<div class="glossary-list-item">/,/<\/div>/p' | perl -ne 'print "$1\n" if/href="(.*)"/' >> "$list_file1"
done

glossary_file="glossary_file.txt"
echo "" > $glossary_file

while read -r line;
do
    curl $line | sed -ne '/<div class="glossary-list-item glossary-term-data">/,/<\/div>/p' | sed 's/<[^>]*>//g' | sed -e 's/^[[:space:]]*//g' | sed '/^$/d' >> $glossary_file
    echo "" >> $glossary_file
    echo "--------------------------------------" >> $glossary_file
    echo "" >> $glossary_file
done < $list_file1

pandoc glossary_file.txt -o glossary_file.pdf
