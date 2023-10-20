extends CanvasLayer

signal quiz
signal correct

var quiz_time = true
var correct_button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Quiz") and quiz_time:
		filling_text()
		quiz.emit()
	
	
func filling_text():
	var random_list = random_multiplication_answers()
	$Container/Question.text = random_list[3]
	$Container/Answers/Answer1.text = str(random_list[0])
	$Container/Answers/Answer2.text = str(random_list[1])
	$Container/Answers/Answer3.text = str(random_list[2])
	correct_button = $Container/Answers.get_children()[random_list[4]]
	quiz_time = false
	
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
	# return a list of 5 elements, the first three are answers, fourth is a question and last one is the postion of the actual answer


func _on_answer_1_button_down():
	if $Container/Answers/Answer1.text == correct_button.text:
		quiz_time = true
		correct.emit()
	else:
		visible = false
		quiz_time = false
		$quizTimer.start()



func _on_quiz_timer_timeout():
	quiz_time = true


func _on_answer_2_button_down():
	if $Container/Answers/Answer2.text == correct_button.text:
		quiz_time = true
		correct.emit()
	else:
		visible = false
		quiz_time = false
		$quizTimer.start()


func _on_answer_3_button_down():
	if $Container/Answers/Answer3.text == correct_button.text:
		quiz_time = true
		correct.emit()
	else:
		visible = false
		quiz_time = false
		$quizTimer.start()
