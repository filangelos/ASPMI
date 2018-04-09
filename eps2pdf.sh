FILES=$(find . -name "*.eps" -type f)
for f in $FILES; do
    ps2pdf -dEPSCrop "$f" "${f%.*}.pdf";
done
