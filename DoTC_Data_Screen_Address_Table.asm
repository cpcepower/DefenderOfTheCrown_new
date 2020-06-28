screen_line0	equ &0000
screen_line1	equ &0800
screen_line2	equ &1000
screen_line3	equ &1800
screen_line4	equ &2000
screen_line5	equ &2800
screen_line6	equ &3000
screen_line7	equ &3800

screen_address_table
	defw screen_width*00+screen_line0,screen_width*00+screen_line1,screen_width*00+screen_line2,screen_width*00+screen_line3,screen_width*00+screen_line4,screen_width*00+screen_line5,screen_width*00+screen_line6,screen_width*00+screen_line7
	defw screen_width*01+screen_line0,screen_width*01+screen_line1,screen_width*01+screen_line2,screen_width*01+screen_line3,screen_width*01+screen_line4,screen_width*01+screen_line5,screen_width*01+screen_line6,screen_width*01+screen_line7
	defw screen_width*02+screen_line0,screen_width*02+screen_line1,screen_width*02+screen_line2,screen_width*02+screen_line3,screen_width*02+screen_line4,screen_width*02+screen_line5,screen_width*02+screen_line6,screen_width*02+screen_line7
	defw screen_width*03+screen_line0,screen_width*03+screen_line1,screen_width*03+screen_line2,screen_width*03+screen_line3,screen_width*03+screen_line4,screen_width*03+screen_line5,screen_width*03+screen_line6,screen_width*03+screen_line7
	defw screen_width*04+screen_line0,screen_width*04+screen_line1,screen_width*04+screen_line2,screen_width*04+screen_line3,screen_width*04+screen_line4,screen_width*04+screen_line5,screen_width*04+screen_line6,screen_width*04+screen_line7
	defw screen_width*05+screen_line0,screen_width*05+screen_line1,screen_width*05+screen_line2,screen_width*05+screen_line3,screen_width*05+screen_line4,screen_width*05+screen_line5,screen_width*05+screen_line6,screen_width*05+screen_line7
	defw screen_width*06+screen_line0,screen_width*06+screen_line1,screen_width*06+screen_line2,screen_width*06+screen_line3,screen_width*06+screen_line4,screen_width*06+screen_line5,screen_width*06+screen_line6,screen_width*06+screen_line7
	defw screen_width*07+screen_line0,screen_width*07+screen_line1,screen_width*07+screen_line2,screen_width*07+screen_line3,screen_width*07+screen_line4,screen_width*07+screen_line5,screen_width*07+screen_line6,screen_width*07+screen_line7
	defw screen_width*08+screen_line0,screen_width*08+screen_line1,screen_width*08+screen_line2,screen_width*08+screen_line3,screen_width*08+screen_line4,screen_width*08+screen_line5,screen_width*08+screen_line6,screen_width*08+screen_line7
	defw screen_width*09+screen_line0,screen_width*09+screen_line1,screen_width*09+screen_line2,screen_width*09+screen_line3,screen_width*09+screen_line4,screen_width*09+screen_line5,screen_width*09+screen_line6,screen_width*09+screen_line7
	defw screen_width*10+screen_line0,screen_width*10+screen_line1,screen_width*10+screen_line2,screen_width*10+screen_line3,screen_width*10+screen_line4,screen_width*10+screen_line5,screen_width*10+screen_line6,screen_width*10+screen_line7
	defw screen_width*11+screen_line0,screen_width*11+screen_line1,screen_width*11+screen_line2,screen_width*11+screen_line3,screen_width*11+screen_line4,screen_width*11+screen_line5,screen_width*11+screen_line6,screen_width*11+screen_line7
	defw screen_width*12+screen_line0,screen_width*12+screen_line1,screen_width*12+screen_line2,screen_width*12+screen_line3,screen_width*12+screen_line4,screen_width*12+screen_line5,screen_width*12+screen_line6,screen_width*12+screen_line7
	defw screen_width*13+screen_line0,screen_width*13+screen_line1,screen_width*13+screen_line2,screen_width*13+screen_line3,screen_width*13+screen_line4,screen_width*13+screen_line5,screen_width*13+screen_line6,screen_width*13+screen_line7
	defw screen_width*14+screen_line0,screen_width*14+screen_line1,screen_width*14+screen_line2,screen_width*14+screen_line3,screen_width*14+screen_line4,screen_width*14+screen_line5,screen_width*14+screen_line6,screen_width*14+screen_line7
	defw screen_width*15+screen_line0,screen_width*15+screen_line1,screen_width*15+screen_line2,screen_width*15+screen_line3,screen_width*15+screen_line4,screen_width*15+screen_line5,screen_width*15+screen_line6,screen_width*15+screen_line7
	defw screen_width*16+screen_line0,screen_width*16+screen_line1,screen_width*16+screen_line2,screen_width*16+screen_line3,screen_width*16+screen_line4,screen_width*16+screen_line5,screen_width*16+screen_line6,screen_width*16+screen_line7
	defw screen_width*17+screen_line0,screen_width*17+screen_line1,screen_width*17+screen_line2,screen_width*17+screen_line3,screen_width*17+screen_line4,screen_width*17+screen_line5,screen_width*17+screen_line6,screen_width*17+screen_line7
	defw screen_width*18+screen_line0,screen_width*18+screen_line1,screen_width*18+screen_line2,screen_width*18+screen_line3,screen_width*18+screen_line4,screen_width*18+screen_line5,screen_width*18+screen_line6,screen_width*18+screen_line7
	defw screen_width*19+screen_line0,screen_width*19+screen_line1,screen_width*19+screen_line2,screen_width*19+screen_line3,screen_width*19+screen_line4,screen_width*19+screen_line5,screen_width*19+screen_line6,screen_width*19+screen_line7
	defw screen_width*20+screen_line0,screen_width*20+screen_line1,screen_width*20+screen_line2,screen_width*20+screen_line3,screen_width*20+screen_line4,screen_width*20+screen_line5,screen_width*20+screen_line6,screen_width*20+screen_line7
	defw screen_width*21+screen_line0,screen_width*21+screen_line1,screen_width*21+screen_line2,screen_width*21+screen_line3,screen_width*21+screen_line4,screen_width*21+screen_line5,screen_width*21+screen_line6,screen_width*21+screen_line7
	defw screen_width*22+screen_line0,screen_width*22+screen_line1,screen_width*22+screen_line2,screen_width*22+screen_line3,screen_width*22+screen_line4,screen_width*22+screen_line5,screen_width*22+screen_line6,screen_width*22+screen_line7
	defw screen_width*23+screen_line0,screen_width*23+screen_line1,screen_width*23+screen_line2,screen_width*23+screen_line3,screen_width*23+screen_line4,screen_width*23+screen_line5,screen_width*23+screen_line6,screen_width*23+screen_line7
	defw screen_width*24+screen_line0,screen_width*24+screen_line1,screen_width*24+screen_line2,screen_width*24+screen_line3,screen_width*24+screen_line4,screen_width*24+screen_line5,screen_width*24+screen_line6,screen_width*24+screen_line7
	defw screen_width*25+screen_line0,screen_width*25+screen_line1,screen_width*25+screen_line2,screen_width*25+screen_line3,screen_width*25+screen_line4,screen_width*25+screen_line5,screen_width*25+screen_line6,screen_width*25+screen_line7
	defw screen_width*26+screen_line0,screen_width*26+screen_line1,screen_width*26+screen_line2,screen_width*26+screen_line3,screen_width*26+screen_line4,screen_width*26+screen_line5,screen_width*26+screen_line6,screen_width*26+screen_line7
	defw screen_width*27+screen_line0,screen_width*27+screen_line1,screen_width*27+screen_line2,screen_width*27+screen_line3,screen_width*27+screen_line4,screen_width*27+screen_line5,screen_width*27+screen_line6,screen_width*27+screen_line7
	defw screen_width*28+screen_line0,screen_width*28+screen_line1,screen_width*28+screen_line2,screen_width*28+screen_line3,screen_width*28+screen_line4,screen_width*28+screen_line5,screen_width*28+screen_line6,screen_width*28+screen_line7
	defw screen_width*29+screen_line0,screen_width*29+screen_line1,screen_width*29+screen_line2,screen_width*29+screen_line3,screen_width*29+screen_line4,screen_width*29+screen_line5,screen_width*29+screen_line6,screen_width*29+screen_line7
	defw screen_width*30+screen_line0,screen_width*30+screen_line1,screen_width*30+screen_line2,screen_width*30+screen_line3,screen_width*30+screen_line4,screen_width*30+screen_line5,screen_width*30+screen_line6,screen_width*30+screen_line7
	defw screen_width*31+screen_line0,screen_width*31+screen_line1,screen_width*31+screen_line2,screen_width*31+screen_line3,screen_width*31+screen_line4,screen_width*31+screen_line5,screen_width*31+screen_line6,screen_width*31+screen_line7
screen_address_table_end
