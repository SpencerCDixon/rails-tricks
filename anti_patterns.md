### Rails Antipatterns

When you create scopes (which are really class methods) in a model the return
value will be a AR proxy object that responds to the normal interface for AR.
One thing you can do to refactor fat models is make a bunch of scopes and then
class methods using those scopes in order to increase readability and only have
1 long SQL statement to the DB.


