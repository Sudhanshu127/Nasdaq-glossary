
for i in a b c d e f g h i j k l m n o p q r s t u v w x y z
do
    curl https://www.nasdaq.com/glossary/$i | sed -ne '/<div class="glossary-list-item">/,/<\/div>/p' | perl -ne 'print "$1\n" if/href="(.*)"/'
done
