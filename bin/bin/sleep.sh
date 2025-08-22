#!/bin/sh
betterlockscreen -l &    # قفل الشاشة
sleep 1                  # انتظر قليلاً لضمان تشغيل القفل
xset dpms force off      # إطفاء الشاشة
doas -n zzz              # وضع النظام في السكون

