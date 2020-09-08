*! 4.0.4 28jun1999
*  3.0.4 23feb1999
*  2.2.1 21sep1998
*  1.2.0 27jul1997  
*  1.0.0 21jun1996   
*  Richard Tucker
program define btscs
    version 5.0
    local varlist "req ex min(3) max(4)"
    local options "Generate(string) Dummy(string) Failure NSPLine(int 0) LSPLine(string)  "
    local if "opt"
    local in "opt"
    parse "`*'"

    if "`generate'" == "" {
         di in r "generate() option required"
         exit 198
    }
    else confirm new variable `generate'

    if "`failure'" ~= "" {
             confirm new variable _tuntilf
             confirm new variable _prefail
             confirm new variable _frstfl
    }

    parse "`varlist'", parse(" ")
    local event   "`1'"
    local tsunit  "`2'"
    local csunit1 "`3'"
    local csunit2 "`4'"

    tempvar touse notuse sting t X V G

    mark `touse' `if' `in'
    markout `touse' `varlist', strok
    gen byte `notuse' = 1 - `touse' 

    quietly {
        sort `notuse' `csunit1' `csunit2' `tsunit'
        by `notuse' `csunit1' `csunit2': ge `sting'= /*
        */ cond(_n > 1,`event'[_n-1], 0)  if `touse'
        by `notuse' `csunit1' `csunit2': replace `sting'=0 if _n==1 & `touse'
        by `notuse' `csunit1' `csunit2': ge `t'=sum(`sting') if `touse'
        sort `notuse' `csunit1' `csunit2' `t'
        ge byte `generate' = .
        by `notuse' `csunit1' `csunit2' `t': replace `generate' = `tsunit' - /*
        */ `tsunit'[1] if `touse'
        label var `generate' "Time since last `event'"
        
        if "`failure'" ~= "" {
             ge byte _tuntilf = .
             ge byte _prefail = .
             by `notuse' `csunit1' `csunit2' `t': replace /*
             */ _tuntilf=`generate'[_N]+1
             sort `notuse' `csunit1' `csunit2' `tsunit'
             by `notuse' `csunit1' `csunit2': replace _prefail= /*
             */ cond(`event'==1, sum(`event')-`event', sum(`event'))
             by `notuse' `csunit1' `csunit2': gen byte _frstfl=_prefail==0 /*
             */ & _prefail[_n+1]==1
             label var _tuntilf "Time until failure"
             label var _prefail "# of previous failures"
             label var _frstfl  "First failure"
        }

/* ------------------------------------------------------------- */

/*   Spline code is ``borrowed" from Sasieni, P. 1994. snp7:
   ``Natural Cubic Splines."  Stata Technical Bulletin 22: 19-22. */

        qui gen `V' = 1 if "`lspline'" ~= "" | `nspline' ~= 0
        if `V' == 1 { 
        quietly {
                gen `X'=`generate' `if' `in'
                count if `X'<.
                local cnt = _result(1)
                if `cnt'<3 { noisily error 2001 }
                local x "`generate'"
                _crcslbl `X' `generate'
                sort `X'
                local kN = `X'[`cnt']
		local k0=`X'[1]
        }
        }

        if `nspline' ~= 0 {
        quietly {
                local nk = `nspline'
                        if `nk' == 0 {
                                local nk = int((`cnt')^.25)
                        }
                        local j = `nk' 
                        while `j' > 0 {
                                local k`j'=`X'[int((`j'*`cnt'/(`nk'+1))+.5)]
                                local j = `j' -1
                        }
                }
        }

        if "`lspline'" ~= "" {
        quietly {
                 parse "`lspline'", parse(" ,")
                        local nk = 0
                        while "`1'"!="" {
                           if "`1'"!=","{
                                if `1'<`k0' | `1'>`kN' {
                                        noisily di "knot at `1' ignored"}
			    	else {
                                	local nk = `nk' + 1
                                        local k`nk' = `1' 
			    	}
			   }
                           macro shift
                        }
        }
        }
        }

        qui gen `G' = 1 if "`lspline'" ~= "" | `nspline' ~= 0
        if `G' == 1 { 
        quietly {
                local j = 1
		local gen1 "`x'" 
                while `j' <= `nk' {
                   confirm new var _spline`j'
        	   #delimit ;
                   gen _spline`j'= -((`kN'-`k`j'')/(`kN'-`k0'))*(`X'-`k0')^3 ;
/* old    replace _spline`j'=_spline`j'+(`X'-`k`j'')^3 if `X'>`k`j'' ; */
                   replace _spline`j'=_spline`j'+(`X'-`k`j'')^3 if `X'>`k`j'' & `k`j'' > `k0' ;
                   replace _spline`j'=(`kN'-`k`j'')*(`k`j''-`k0')
				*(`kN'+`k`j''+`k0'-3*`X')	if `X'>`kN' ;
        	   #delimit cr
                   lab var _spline`j' "(`x'-k`j') cubed"
                   local gen1 "`gen1' _spline`j'"
                   local j = `j' +1
                }
                mac def _spline "`gen1'"
        }
        }

/* ------------------------------------------------------------- */

        if "`dummy'" ~= "" {
             sum `generate' `if' `in', meanonly
             local i = _result(5)
             local j = _result(6)
             while `i' <= `j' {
                  capture confirm new variable _`dummy'`i'
                  if _rc {
                        display in red "_`dummy'`i' already exists" 
                        drop `generate'
                        if "`failure'" ~= "" {
                             drop _tuntilf
                             drop _prefail
                             drop _frstfl
                        }
                        /* drop _`dummy'* */
                        display ""
                        display in red "CAUTION: change dummy variable prefix"
                     /* display in red "CAUTION: all dummy variables dropped " */
                        exit 110
                  }
                  local i = `i' + 1
             }
             sum `generate' `if' `in', meanonly
             local i = _result(5)
             local j = _result(6)
             while `i' <= `j' {
                  gen byte _`dummy'`i' = `generate' == `i'
                  label var _`dummy'`i' "Temporal dummy, `generate'=`i'"
                  local i = `i' + 1
             }
         }
    /* } */

             sort `csunit1' `csunit2' `tsunit'

end

