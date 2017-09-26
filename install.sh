rm -f underscore.min.js &&\
rm -f www/js/lib/underscore.js &&\
wget http://underscorejs.org/underscore-min.js &&\
mv underscore-min.js www/js/lib/underscore.js &&\

rm -f jquery-3.2.1.js &&\
rm -f www/js/lib/jquery.js &&\
wget https://code.jquery.com/jquery-3.2.1.js &&\
mv jquery-3.2.1.js www/js/lib/jquery.js &&\

rm -f angular-route.min.js &&\
rm -f www/js/lib/angular-route.js &&\
wget https://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular-route.min.js &&\
mv angular-route.min.js www/js/lib/angular-route.js &&\

rm -f angular-cookies.min.js &&\
rm -f www/js/lib/angular-cookies.js &&\
wget https://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular-cookies.min.js &&\
mv angular-cookies.min.js www/js/lib/angular-cookies.js &&\

rm -f angular-sanitize.min.js &&\
rm -f www/js/lib/angular-sanitize.js &&\
wget https://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular-sanitize.min.js &&\
mv angular-sanitize.min.js www/js/lib/angular-sanitize.js &&\

rm -f angular-animate.min.js &&\
rm -f www/js/lib/angular-animate.js &&\
wget https://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular-animate.min.js &&\
mv angular-animate.min.js www/js/lib/angular-animate.js &&\

rm -f angular-aria.min.js &&\
rm -f www/js/lib/angular-aria.js &&\
wget https://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular-aria.min.js &&\
mv angular-aria.min.js www/js/lib/angular-aria.js &&\

rm -f angular-messages.min.js &&\
rm -f www/js/lib/angular-messages.js &&\
wget https://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular-messages.min.js &&\
mv angular-messages.min.js www/js/lib/angular-messages.js &&\

rm -f angular-material.min.js &&\
rm -f www/js/lib/angular-material.js &&\
wget https://ajax.googleapis.com/ajax/libs/angular_material/1.1.0/angular-material.min.js &&\
mv angular-material.min.js www/js/lib/angular-material.js &&\

rm -f angular.min.js &&\
rm -f www/js/lib/angular.js &&\
wget https://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular.min.js &&\
mv angular.min.js www/js/lib/angular.js &&\

rm -f font-awesome-4.7.0.zip &&\
rm -f www/css/fonts/* &&\
rm -f www/css/lib/font-awesome.css &&\
rm -rf font-awesome-4.7.0 &&\
wget http://fontawesome.io/assets/font-awesome-4.7.0.zip &&\
unzip font-awesome-4.7.0.zip &&\
rm font-awesome-4.7.0.zip &&\
mv font-awesome-4.7.0/css/font-awesome.min.css www/css/lib/font-awesome.css &&\
mv font-awesome-4.7.0/fonts/* www/css/fonts &&\
rm -r font-awesome-4.7.0 &&\

rm -f v1.6.4.zip &&\
rm -rf Framework7-1.6.4 &&\
rm -f www/js/lib/framework7.js &&\
rm -f www/css/lib/framework7.material.css &&\
rm -f www/css/lib/framework7.material.colors.css &&\
wget https://github.com/nolimits4web/Framework7/archive/v1.6.4.zip &&\
unzip v1.6.4.zip &&\
rm v1.6.4.zip &&\
mv Framework7-1.6.4/dist/js/framework7.min.js www/js/lib/framework7.js &&\
mv Framework7-1.6.4/dist/css/framework7.material.min.css www/css/lib/framework7.material.css &&\
mv Framework7-1.6.4/dist/css/framework7.material.colors.min.css www/css/lib/framework7.material.colors.css &&\
rm -r Framework7-1.6.4 &&\

rm -f master.zip &&\
rm -rf angular-file-upload-master &&\
rm -f www/js/lib/angular-file-upload.js &&\
wget https://github.com/nervgh/angular-file-upload/archive/master.zip &&\
unzip master.zip &&\
rm master.zip &&\
mv angular-file-upload-master/dist/angular-file-upload.min.js www/js/lib/angular-file-upload.js &&\
rm -r angular-file-upload-master
