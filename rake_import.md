## How To Create An Import Rake Task

**Step 1**: Creating tests.  Looks something like this:

This is assuming we have a lesson model and we are trying to import lessons in
markdown for our app. First we are creating a data folder in our spec folder to
store all our sample lessons which we will be importing in our tests.  

```ruby
  describe '.import!' do
    let(:sample_lessons_dir) { Rails.root.join("spec/data/sample_lessons") }

    it "creates a new lesson" do
      Lesson.import!(File.join(sample_lessons_dir, "expressions"))

      expect(Lesson.count).to eq(1)

      lesson = Lesson.find_by!(slug: "expressions")
      expect(lesson.title).to eq("Expressions")
      expect(lesson.type).to eq("article")
      expect(lesson.description).to eq("bloop.")
      expect(lesson.body).to eq("beep boop i'm an expression\n")
      expect(lesson.position).to eq(1)
    end
  end
```

**Step 2**: Build the import method!  So first we tell the import method to
fetch all the attributes needed to build a lesson using the .lesson.yml file

```ruby
  def self.import!(source_dir)
    attributes = YAML.load_file(File.join(source_dir, ".lesson.yml"))
  end
```


In this method I am using the source_dir (the name of the directory of the
lesson being uploaded) as the slug for the lessons.  Then it's using the
.lesson.yml in order to build all the attributes for a lesson.

```ruby
  def self.import!(source_dir)
    slug = File.basename(source_dir)

    attributes = YAML.load_file(File.join(source_dir, ".lesson.yml"))
    content = File.read(File.join(source_dir, "#{slug}.md"))

    lesson = Lesson.find_or_initialize_by(slug: slug)
    lesson.slug = slug
    lesson.body = content
    lesson.title = attributes["title"]
    lesson.lesson_type = attributes["type"]
    lesson.description = attributes["description"]

    lesson.save!
  end
```

Here is what the .lesson.yml looks like:  
```yaml
---
title: "Variable Assignment"
type: "article"
description: "How to assign variables in Ruby"
tags: "ruby, variables"
---
```


