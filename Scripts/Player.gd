extends CharacterBody2D

# ─────────────── STATES ───────────────
var states          = ["idle", "run", "dash", "fall", "jump", "double_jump"]
var currentState    = states[0]
var previousState   = null

# ───────────── SPRITES & ANIMATION ─────────────
@onready var PlayerSprite     = $Sprite2D
@onready var PlayerAnimation  = $AnimationPlayer
@onready var RightRaycast     = $RightRaycast
@onready var LeftRaycast      = $LeftRaycast

# ───────────── MOVEMENT CONSTANTS ─────────────
var recoverySpeed     = 0.03
var landingSquash     = 1.5
var landingStretch    = 0.5
var jumpingSquash     = 0.5
var jumpingStretch    = 1.5

var maxSpeed          = 190
var acceleration      = 25
var decceleration     = 40
var airFriction       = 60
var gravity           = 700

var dashSpeed         = 60
var dashDurration     = 160
var canDash           = true
var dashDirection     = 1
var dashStartTime
var elapsedDashTime

var jumpHeight        = 64
var doubleJumpHeight  = 32
var wallJumpHeight    = 128

var jumpVelocity
var doubleJumpVelocity
var wallJumpVelocity

var wallSlideSpeed    = 50
var isDoubleJumped    = false

var respawn_position: Vector2
var game_paused = false

# ───────────── INPUT / STATE VARS ─────────────
var movementInput     = 0
var lastDirection     = 1

var isJumpPressed     = 0
var isJumpReleased
var isDashPressed

var jumpInput         = 0
var coyoteStartTime   = 0
var elapsedCoyoteTime = 0
var coyoteDuration    = 100

var jumpBufferStartTime = 0
var elapsedJumpBuffer   = 0
var jumpBuffer          = 100

var currentSpeed     = 0

# ───────────── READY ─────────────
func _ready():
	jumpVelocity         = -sqrt(2 * gravity * jumpHeight)
	doubleJumpVelocity   = -sqrt(2 * gravity * doubleJumpHeight)
	wallJumpVelocity     = -sqrt(2 * gravity * wallJumpHeight)
	respawn_position = global_position
	process_mode = Node.PROCESS_MODE_PAUSABLE

# ───────────── PHYSICS LOOP ─────────────
func _physics_process(delta):
	get_input()
	apply_gravity(delta)
	call(currentState + "_logic", delta)
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	recover_sprite_scale()
	PlayerSprite.flip_h = lastDirection - 1

# ───────────── INPUT HANDLING ─────────────
func get_input():
	movementInput = Input.get_action_strength("right") - Input.get_action_strength("left")
	if movementInput != 0:
		lastDirection = movementInput

	isJumpPressed = Input.is_action_just_pressed("jump")
	isJumpReleased = Input.is_action_just_released("jump")
	isDashPressed = Input.is_action_just_pressed("dash")

	if jumpInput == 0 and isJumpPressed:
		jumpInput = 1
		coyoteStartTime = Time.get_ticks_msec()

	elapsedCoyoteTime = Time.get_ticks_msec() - coyoteStartTime
	if jumpInput != 0 and elapsedCoyoteTime > coyoteDuration:
		jumpInput = 0
		coyoteStartTime = 0
	
	if Input.is_action_just_pressed("Quit"):
		print("Quit")
		get_tree().quit()
	
	if Input.is_action_just_pressed("Menu"):
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
	
	#if Input.is_action_just_pressed("Pause"):
	#	print("Pause toggled")
	#	if !game_paused:
	#		get_tree().paused = true
	#		game_paused = true
	#	else:
	#		get_tree().paused = false
	#		game_paused = false


	
# ───────────── CORE MOVEMENT ─────────────
func apply_gravity(delta):
	if currentState != "dash":
		velocity.y += gravity * delta

func move_horizontally(_subtractor):
	currentSpeed = move_toward(currentSpeed, maxSpeed, acceleration)
	velocity.x = currentSpeed * movementInput

func recover_sprite_scale():
	PlayerSprite.scale.x = move_toward(PlayerSprite.scale.x, 1, recoverySpeed)
	PlayerSprite.scale.y = move_toward(PlayerSprite.scale.y, 1, recoverySpeed)

func squash_stretch(squash, stretch):
	PlayerSprite.scale.x = squash
	PlayerSprite.scale.y = stretch

func jump(_jump_velocity):
	AudioManager.jump_sfx.play()
	velocity.y = _jump_velocity
	canDash = true
	squash_stretch(jumpingSquash, jumpingStretch)

func set_state(new_state: String):
	previousState = currentState
	currentState = new_state
	if previousState != null:
		call(previousState + "_exit_logic")
	if currentState != null:
		call(currentState + "_enter_logic")

# --------------- Signals -------------
func die():
	print("Player Died")
		#death animation
	AudioManager.death_sfx.play()
	global_position = respawn_position
	velocity = Vector2.ZERO


# ───────────── STATE LOGIC ─────────────

# --- IDLE ---
func idle_enter_logic():
	PlayerAnimation.play("Idle")

func idle_logic(_delta):
	if jumpInput:
		jump(jumpVelocity)
		set_state("jump")
	elif isDashPressed:
		set_state("dash")
	elif movementInput != 0:
		set_state("run")
	velocity.x = move_toward(velocity.x, 0, decceleration)

func idle_exit_logic():
	currentSpeed = 0

# --- RUN ---
func run_enter_logic():
	PlayerAnimation.play("Run")

func run_logic(_delta):
	if jumpInput:
		jump(jumpVelocity)
		set_state("jump")
	elif isDashPressed:
		set_state("dash")
	elif !is_on_floor():
		jumpBufferStartTime = Time.get_ticks_msec()
		set_state("fall")
	elif movementInput == 0:
		set_state("idle")
	else:
		move_horizontally(0)

func run_exit_logic():
	pass

# --- FALL ---
func fall_enter_logic():
	PlayerAnimation.play("Fall")

func fall_logic(_delta):
	move_horizontally(airFriction)
	elapsedJumpBuffer = Time.get_ticks_msec() - jumpBufferStartTime

	if isJumpPressed:
		if !isDoubleJumped and elapsedJumpBuffer > jumpBuffer:
			jump(doubleJumpVelocity)
			set_state("double_jump")
		elif elapsedJumpBuffer < jumpBuffer:
			if previousState == "run":
				jump(jumpVelocity)
				set_state("jump")
			elif previousState == "wall_slide":
				jump(wallJumpVelocity)
				set_state("wall_jump")

	if isDashPressed and canDash:
		set_state("dash")
	elif is_on_floor():
		set_state("run")
		isDoubleJumped = false
		squash_stretch(landingSquash, landingStretch)
	elif (LeftRaycast.is_colliding() and movementInput == -1) or (RightRaycast.is_colliding() and movementInput == 1):
		set_state("wall_slide")

func fall_exit_logic():
	jumpBufferStartTime = 0

# --- DASH ---
func dash_enter_logic():
	dashDirection = lastDirection
	dashStartTime = Time.get_ticks_msec()
	velocity = Vector2.ZERO
	PlayerAnimation.play("Idle")
	PlayerSprite.modulate = Color.PURPLE

func dash_logic(_delta):
	elapsedDashTime = Time.get_ticks_msec() - dashStartTime
	velocity.x += dashSpeed * dashDirection
	if elapsedDashTime > dashDurration:
		set_state(previousState)

func dash_exit_logic():
	velocity = Vector2.ZERO
	if !is_on_floor():
		canDash = false
	PlayerSprite.modulate = Color.WHITE

# --- JUMP ---
func jump_enter_logic():
	PlayerAnimation.play("Jump")

func jump_logic(_delta):
	move_horizontally(airFriction)
	if velocity.y < 0:
		if isJumpReleased:
			velocity.y /= 2
		elif isJumpPressed and !isDoubleJumped:
			jump(doubleJumpVelocity)
			set_state("double_jump")
		elif isDashPressed and canDash:
			set_state("dash")
		elif is_on_ceiling():
			set_state("fall")
	else:
		set_state("fall")

func jump_exit_logic():
	pass

# --- DOUBLE JUMP ---
func double_jump_enter_logic():
	isDoubleJumped = true
	PlayerAnimation.play("Double Jump")

func double_jump_logic(_delta):
	move_horizontally(airFriction)
	if velocity.y < 0:
		if isJumpReleased:
			velocity.y /= 2
		elif isDashPressed and canDash:
			set_state("dash")
		elif is_on_ceiling():
			set_state("fall")
	else:
		set_state("fall")

func double_jump_exit_logic():
	pass

# --- WALL SLIDE ---
func wall_slide_enter_logic():
	velocity = Vector2.ZERO
	PlayerAnimation.play("Wall Slide")

func wall_slide_logic(_delta):
	velocity.y = wallSlideSpeed

	if (LeftRaycast.is_colliding() and movementInput != -1) or (RightRaycast.is_colliding() and movementInput != 1):
		jumpBufferStartTime = Time.get_ticks_msec()
		set_state("fall")

	elif (!LeftRaycast.is_colliding() and movementInput == -1) or (!RightRaycast.is_colliding() and movementInput == 1):
		set_state("fall")

	elif is_on_floor():
		jumpBufferStartTime = Time.get_ticks_msec()
		set_state("idle")

	elif isDashPressed:
		set_state("dash")

	elif isJumpPressed:
		jump(wallJumpVelocity)
		set_state("wall_jump")

func wall_slide_exit_logic():
	isDoubleJumped = false

# --- WALL JUMP ---
func wall_jump_enter_logic():
	currentSpeed = 0
	PlayerAnimation.play("Jump")

func wall_jump_logic(_delta):
	move_horizontally(airFriction)
	if velocity.y < 0:
		if isJumpReleased:
			velocity.y /= 2
		elif isJumpPressed and !isDoubleJumped:
			jump(doubleJumpVelocity)
			set_state("double_jump")
		elif isDashPressed:
			set_state("dash")
		elif is_on_ceiling():
			set_state("fall")
	else:
		set_state("fall")

func wall_jump_exit_logic():
	canDash = true
