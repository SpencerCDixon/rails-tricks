## Junior to Senior Developer

I decided to do some research on what qualifies someone as an entry level/junior
developer vs. senior.  Hoping to do some interviews with top Rails developers in
the Boston area to gain insight.  For now, I will document the process here.

### Entry Level/Junior Traits

*  Just out of school/bootcamp  
*  Assigned least complex coding tasks  
*  Make naive choices just to get code done/working  
*  Unaware of the bigger picture/design requirements  
*  Poor debugging skills/prematurely ask for help  
*  Know about 10% of what they think they know  

**What should their focus be?** (personal opinion/hypothesis)
*  Developing good relationships with co-workers/seniors so they have many
    places to go for help.  
*  Extreme humility.  Ask lots of questions.  Extreme desire to know WHY not
    just HOW/WHAT  
*  Reading lots of books/learning their stack inside and out  
*  Learning quirks of their language  
*  Start learning and using OO principles  


### Advanced Junior/Intermediate Developer Traits

*  2 - 10 years experience (generally, not always)  
*  Produce working code with less supervision  
*  Generally more focused areas of an app instead of high level design decisions
    or complicated tasks  
*  Good at maintenance tasks  
*  Decent at debugging. Sometimes get stuck on something for long time though.  
*  Have been through the whole dev cycle at least once and starting to recognize
    patterns to avoid.  
*  Take requirements at face value and don't push back when there might be a
    problem.  I.E. lack design confidence.  
*  Work horses of code.  Produce 80-90% of the code however only 10% of that is
    the more difficult stuff which is where Senior time is usually spent.  

**What should their focus be?** (personal opinion/hypothesis)
*  Mastering OO principles  
*  Re-building simple versions of the tools they use.  I.E. gems/frameworks  
*  Start thinking about business requirements more  
*  Reading through Senior's code whenever possible  
*  Practice communication skills with juniors.  Get good at figuring out where
    people are coming from  
*  Start getting depth in specific area or two of programming  
*  Start mastering a second language, don't just play with it  
*  Develop better problem solving/debugging skills.  Start recognizing patterns
    more  

### Senior Developer Traits

*  Better at project management/estimating and planning  
*  Able to communicate technical needs to a team and non tech stakeholders  
*  Self-sufficient/autonomous  
*  Experts in their stack/language.  Often experts in 2+ languages  
*  Amazing trouble shooters, know where to go to get answers quickly as possible  
*  Know which corners can be cut and which can't through experience and past
    rabbit holes  
*  Sought after for advice and gives talks at conferences frequently  
*  Good at getting knowledge about the business domain they support and not just
    code  
*  Seek out places with the most interesting problems  

**What should their focus be?** (personal opinion/hypothesis)
*  Mentoring intermediate developers  
*  Create a bridge between the tech and non tech people  
*  Master the business domain of their technology  
*  Continue learning new languages  
*  Find places with challenging/interesting problems 


### Identifying Which Corners Can Be Cut?
Advice from Dan Pickett:

1.  Tests will always be necessary, the longer you wait, the more technical debt
accrues.  
2.  Consider database operations at scale.  I.E. what happens when there are
1,000,000 / 10,000,000?  
3.  You can't be your own QA person.  
4.  Eventually, you will have to relegate expensive operations into a queue or
background process.  
5.  Listen to your intuition, if you feel an urge to refactor then you probably
should.  

### Going From Junior To Intermediate

Today I decided to spend some time reflecting on what types of things I did in order
to go from junior to more intermediate. Here are my outcomes:


#### Focus
Focus is important. When you're new there are so many things that you
want/feel like you need to learn that it can be overwhelming and paralyze
you from taking action.  The best way to overcome that is to have targeted
learning goals over a finite amount of time.  When I was new I did 2-week
cycles.  So, I'd spend 2 weeks only learning about Ruby.  Once that was up I'd
transition to 2 weeks about OO principles.. etc.

#### Information Sources 
Most of my learning has come from reading and applying concepts I read about.  I
fully realize not everyone likes to read but that's a story in your brain you
need to get over if you want to become an outstanding developer (or outstanding at anything for
that matter).  With code there are lots of other ways to level up though besides
reading which I totally use:

*  Look at other peoples code and figure out how its working.  
*  Listen to podcasts.  For Ruby I really like [The Ruby
    Rogues](http://devchat.tv/ruby-rogues/)  
*  Build lots of projects.  My github is FLOODED with small projects or half
    built projects that I used for a single purpose; learn something.  
*  Try and have projects for each cycle/campaign.  Have small projects you want to build
    for your 2 week cycles but also have bigger projects/goals for every 2-3
    months.  I.E. by the end of the next 3 months I will have built a basic
    Backbone App.  
*  Ask a shit ton of questions to other developers who are better than you.
    Actually listen to the advice.  

#### Active Reading
When you read books don't just read the words and move on.  Make sure you
understand what it's teaching and how/where you would apply that concept.  Take
notes as you read of when you would apply a certain concept.  Build all the apps
in the examples and use `pry` or `irb` a lot to get a better understanding of
how Ruby works.

**Book List**:
**Ruby:**
*  POODR (read multiple times)
*  Well Grounded Rubyist, read chapter a day and compile document of all the things you didn’t know ruby could do  
*  Eloquent Ruby  
*  The Ruby Way (newest edition is dope)  Just read here and there whenever your
    bored.  
*  Metaprogramming 2 - solidify your understanding of inheritance and get into
    some fun programming concepts/what makes Ruby great.  

**Rails:**
*  Rails 4 Way - read first 12 chapters word by word, then use rest as a
    reference.  Read through different sections/chapters of the book whenever
    you start working on a specific feature in a rails app.  It helps to learn
    with context  
*  Rails 4 Test Perscriptions - gives some guidance on how to write better
    tests.  
*  Ruby Science - thoughtbot's ebook on common Rails patterns to start
    recognizing
*  Rails 3 Anti-Patterns - best book ever to learn what NOT to do.  Relatively
    quick read too.  
*  Rebuilding Rails - once your confident with Rails its great to use to learn
    Rack and how web frameworks work on a deeper level.  

**Javascript:**
Stop trying to learn Javascript until you actually know how ruby and Rails
works.  Unless you get a job working in JS you are wasting time.  Once you
get to a more intermediate level you can come back to JS.  Feel free to read
like eloquent JS but to actually learn it takes a significant amount of time.
90% of the time you will be looking through documentation anyways to get what
you want done.  Until you are ready to FULLY commit to learning JS I'd put
energy into Ruby/Rails mastery.


#### Skills Matrix 
This is an idea I adopted from when I had a life coach.  The concept is to grade
all the areas of your life on a 1-10 scale so you know where you need to put
more time/energy.  I use the same concept but for leveling up my dev skills.  I
try and revisit my skills matrix every 2-3 months to see what adjustments need
to be made and how I can plan out my next few sprints/campaigns of learning.





