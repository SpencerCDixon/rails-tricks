# Image Preview With Carrierwave

Had a hard time finding good resources for implementing image preview in Rails
with carrierwave.  Here's how I did it:

```ruby
# ... rest of the form ...

# Your carrierwave image uploader
<div class="form-group">
  <img id="img_prev" width=300 height=300 src="#" alt="your image" class="img-thumbnail hidden"/> <br/>
  <span class="btn btn-default btn-file">
    Upload Avatar Image<%= f.file_field :avatar, id: "avatar-upload" %>
  </span>
  <%= f.hidden_field :avatar_cache %>
</div>
```

This is the javascript that will create an event handler on change for the file
uploading input tag and display the image on the screen.  I applied some basic
bootstrap classes to the image.

```javascript
$(function() {
  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#img_prev').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }

  $("#avatar-upload").change(function(){
    $('#img_prev').removeClass('hidden');
    readURL(this);
  });
});
```
