extends CanvasLayer

signal quiz
signal correct(question_type)

var quiz_time = true
var correct_button
var test_type = "addition"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(_delta):
	if Input.is_action_just_pressed("Quiz1") and quiz_time:
		filling_text(test_type)
		quiz.emit()
	
		
	
	
func filling_text(type_of_test):
	var random_list
	if type_of_test == "multiplication":
		random_list = random_multiplication_answers()
	elif type_of_test == "algebra":
		random_list = random_algebraic_answers()
	elif type_of_test == "addition":
		random_list = random_addition_answers()
	$Container/Question.text = random_list[3]
	$Container/Answers/Answer1.text = str(random_list[0])
	$Container/Answers/Answer2.text = str(random_list[1])
	$Container/Answers/Answer3.text = str(random_list[2])
	correct_button = $Container/Answers.get_children()[random_list[4]]
	quiz_time = false
	
	
func random_addition_answers():
	var num1 = randi() % 12 + 1
	var num2 = randi() % 12 + 1
	var num3 = randi() % 12 + 1
	var which_one = randi() % 3 
	var option1 = num1 + num2
	var option2 = num1 + num3
	var option3 = num2 + num3
	var question 
	if which_one == 2:
		question = "What is " + str(num2) + " + " + str(num3)
	elif  which_one == 1:
		question = "What is " + str(num1) + " + " + str(num3)
	else:
		question = "What is " + str(num1) + " + " + str(num2)
	return [option1, option2, option3, question, which_one]
	
func random_multiplication_answers():
	var num1 = randi() % 12 + 1
	var num2 = randi() % 12 + 1
	var num3 = randi() % 12 + 1
	var which_one = randi() % 3 
	var option1 = num1 * num2
	var option2 = num1 * num3
	var option3 = num2 * num3
	var question 
	if which_one == 2:
		question = "What is " + str(num2) + " X " + str(num3)
	elif  which_one == 1:
		question = "What is " + str(num1) + " X " + str(num3)
	else:
		question = "What is " + str(num1) + " X " + str(num2)
	return [option1, option2, option3, question, which_one]
	# return a list of 5 elements, the first three are answers, fourth is the question and last one is the postion of the actual answer
func random_algebraic_answers():
	var num1 = randi() % 12 + 1
	var num2 = randi() % 12 + 1
	var num3 = randi() % 12 + 1
	var which_one = randi() % 3 
	var y = num2*num3
	var m = num1
	var b = num2
	var option1 = str(y-b)+ "/" + str(m)
	var option2 = str(b+m)+"/" + str(y)
	var option3 = str(m-y)+ "/"+ str(b)
	
	var question 
	if which_one == 2:
		question = "Solve for x:    " + str(-b) + "x  +" + str(m) + "=" + str(y)
	elif  which_one == 1:
		question = "Solve for x:    " + "(" + str(b) + " + " + str(m) + ")/x" + "=" + str(y)
	else:
		question = "Solve for x:    " + str(m) + "x  +" + str(b) + "=" + str(y)
	return [option1, option2, option3, question, which_one]
	
func _on_quiz_timer_timeout():
	quiz_time = true
	


func _on_easy_button_button_down():
	test_type = "addition"


func _on_medium_button_button_down():
	test_type = "multiplication"

func _on_hard_button_button_up():
	test_type = "algebra"
	
	
func _on_answer_1_button_up():
	if int($Container/Answers/Answer1.text) == int(correct_button.text):
		quiz_time = true
		correct.emit(test_type)
	else:
		visible = false
		quiz_time = false
		$quizTimer.start()
	Global.shootable = true



func _on_answer_2_button_up():
	if int($Container/Answers/Answer2.text) == int(correct_button.text):
		quiz_time = true
		correct.emit(test_type)
	else:
		visible = false
		quiz_time = false
		$quizTimer.start()
	Global.shootable = true

func _on_answer_3_button_up():
	if int($Container/Answers/Answer3.text) == int(correct_button.text):
		quiz_time = true
		correct.emit(test_type)
	else:
		visible = false
		quiz_time = false
		$quizTimer.start()
	Global.shootable = true






