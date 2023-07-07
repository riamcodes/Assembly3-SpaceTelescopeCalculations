		.syntax     unified
		.cpu        cortex-m4

		.data
		.align
consMs:
		.float		2.0e30
consMe:
		.float		5.98e24
consRe:
		.float		1.50e11

		.text
		.global		JWST
		.thumb_func
		.align
// Arguments:
//   R0 = x array pointer
//   R1 = f(x) array pointer
//   S0 = xfirst, x
//   S1 = xlast
// Uses:
//   R2 = i
//   R3 = loaded in constants 
//   R12 = 
//   S2 = Ms
//   S3 = Me
//   S4 = Re
//   S5 = xinc
//   S6 = p
//   S7 = q
//   S8 = x
//   S9 = constant
//   S10 
JWST:
// Your assembly code goes here

//Load the value of the constants Ms, Me, and Re from memory into
//registers


LDR R3, =consMs
VLDR S2, [r3]    // put the value of r3 into S2

LDR R3, =consMe
VLDR S3, [r3]

LDR R3, =consRe
VLDR S4, [r3]
 


//Compute xinc = ( xlast −xfirst )/10.0
VSUB.F32 S5, S1, S0
VMOV S9, #10.0
VDIV.F32 S5, S5, S9



//Set x = xfirst
VMOV S8, S0


//Set i = 0
MOV R2, 0


checki: 

//While i < 11 do 
CMP R2, 11
BHS ends 
//if greater than 11 jump to ends 


//Compute p 
//p = x/Re
 VDIV.F32 S6, S8, S4

//Compute q
//q = p+1
VMOV S9, #1.0
VADD.F32 S7, S6, S9

//Compute f(x)
 //f(x) = q3 p2 ms − p2 ms − q2 me
 //S9 is also a useless constant rn so it can be repalced 
VMUL.F32 S9, S6, S6 //p^2 stored in S9
VMUL.F32 S9, S2  // p2 ms stored in S9
VMUL.F32 S10, S9, S7 //p2 ms x q stored in S10
VMUL.F32 S10, S7 //p2 ms x q^2 stored in S10
VMUL.F32 S10, S7 // p2 ms x q^3 Stored in S10
VSUB.F32 S10, S9 // first part of the equation stored into S10
VMOV S9, S7 //S9 now contains q
VMUL.F32 S9, S7 //S9 now contains q squared
VMUL.F32 S9, S3 //S9 now contains q squared x me
VSUB.F32 S10, S9 // whole f(x) equation is now in S10

//Store x into the x array, index i
VSTR S8, [R0]
ADD R0, #4

//Store f(x) into the f array, index i
//STR ??? Second array?
VSTR  S10, [R1]
ADD R1, #4

//Increment i
ADD R2, 1

//Set x = x + xinc
VADD.F32 S8, S5
//End while
b checki


//Return


 ends:
		bx	lr
		.end
