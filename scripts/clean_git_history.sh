#!/bin/bash

# Git History Temizleme Scripti
# Bu script, hassas bilgileri git history'den temizler
# DİKKAT: Bu işlem geri alınamaz!

set -e

echo "⚠️  UYARI: Bu script git history'yi kalıcı olarak değiştirecektir!"
echo "📋 Temizlenecek dosyalar:"
echo "   - lib/firebase_options.dart"
echo "   - android/app/google-services.json"
echo ""
read -p "Devam etmek istiyor musunuz? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ İşlem iptal edildi."
    exit 1
fi

echo ""
echo "🔍 Git history kontrol ediliyor..."

# BFG Repo-Cleaner kullanımı (önerilen yöntem)
if command -v java &> /dev/null; then
    echo "📥 BFG Repo-Cleaner indiriliyor..."
    wget -q https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar -O /tmp/bfg.jar
    
    echo "🧹 Hassas dosyalar temizleniyor..."
    java -jar /tmp/bfg.jar --delete-files firebase_options.dart
    java -jar /tmp/bfg.jar --delete-files google-services.json
    
    echo "🧹 Git temizleniyor..."
    git reflog expire --expire=now --all
    git gc --prune=now --aggressive
    
    echo "✅ Git history temizlendi!"
    echo ""
    echo "📝 Sonraki adımlar:"
    echo "   1. Değişiklikleri kontrol edin: git log"
    echo "   2. Eğer memnunsanız force push yapın:"
    echo "      git push origin --force --all"
    echo "      git push origin --force --tags"
    echo ""
    echo "⚠️  DİKKAT: Force push yapmadan önce backup alın!"
    
    rm -f /tmp/bfg.jar
else
    echo "❌ Java bulunamadı. BFG Repo-Cleaner kullanılamıyor."
    echo ""
    echo "Alternatif yöntem: Git filter-branch"
    echo ""
    read -p "Git filter-branch kullanmak istiyor musunuz? (yes/no): " use_filter
    
    if [ "$use_filter" = "yes" ]; then
        echo "🧹 Git filter-branch çalıştırılıyor..."
        git filter-branch --force --index-filter \
          "git rm --cached --ignore-unmatch lib/firebase_options.dart android/app/google-services.json" \
          --prune-empty --tag-name-filter cat -- --all
        
        echo "🧹 Git temizleniyor..."
        git reflog expire --expire=now --all
        git gc --prune=now --aggressive
        
        echo "✅ Git history temizlendi!"
        echo ""
        echo "📝 Sonraki adımlar:"
        echo "   1. Değişiklikleri kontrol edin: git log"
        echo "   2. Eğer memnunsanız force push yapın:"
        echo "      git push origin --force --all"
        echo "      git push origin --force --tags"
    else
        echo "❌ İşlem iptal edildi."
        exit 1
    fi
fi

