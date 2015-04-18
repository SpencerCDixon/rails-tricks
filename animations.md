# Adding Animations to Rails

1.  Download animate.css  
2.  Put in vendor/assets/stylsheets  
3.  In application.scss add this line: `*= require animate`  
4.  Set up some JS to add animation classes when I want them.  

Alternatively, you can use [this gem which does those things for
you](https://github.com/camelmasa/animate-rails)


When adding transitions/transforms to my css here are some neat tricks:
```css
.profile-icon {
  transition: all .2s ease-in-out;
  &:hover {
    transform: scale(1.3);
  }
}

.fa-heart.profile-icon:hover {
  color: #8A0707;
}

.fa-bar-chart.profile-icon:hover {
  color: #0B486B;
}

.fa-comments-o.profile-icon:hover {
  color: #3B8686;
}
```
