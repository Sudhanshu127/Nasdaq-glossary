list_file1="listfile.txt"
echo "" > $list_file1

echo "Fetching all the glossary words"

for i in a b c d e f g h i j k l m n o p q r s t u v w x y z
do
    curl -s https://www.nasdaq.com/glossary/$i | sed -ne '/<div class="glossary-list-item">/,/<\/div>/p' | perl -ne 'print "$1\n" if/href="(.*)"/' >> "$list_file1"
done

glossary_file="glossary_file.txt"
echo "" > $glossary_file
let i=0
j=$(wc -l $list_file1 | grep -oP "[0-9]*")

echo "Fetching data for each item. Total items are "$j

while read -r line;
do
    curl -s $line | sed -ne '/<div class="glossary-list-item glossary-term-data">/,/<\/div>/p' | sed 's/<[^>]*>//g' | sed -e 's/^[[:space:]]*//g' | sed '/^$/d' >> $glossary_file
    echo "" >> $glossary_file
    echo "--------------------------------------" >> $glossary_file
    echo "" >> $glossary_file
    let i++
    echo -ne $i' / '$j'\r'
done < $list_file1
echo '\n'

echo "Converting txt to pdf"

pandoc glossary_file.txt --pdf-engine=xelatex -o glossary_file.pdf

echo "We are done."