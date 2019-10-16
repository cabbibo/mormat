using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BindForm : Binder
{
    

    public string transformName;
    public Form form;
    public override void Bind(){
      toBind.BindForm( transformName, form );
    }


}
