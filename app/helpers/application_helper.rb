module ApplicationHelper

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    devise_mapping.to
  end

  def devise_mapping
   @devise_mapping ||= Devise.mappings[:user]
  end

  def user_generated_content_credit(user)
    ''
  end

  def full_title(page_title = '', category='')
    base_title = "Bound Round"
    if category.empty?
      if page_title.empty?
        "Activities, Reviews and Things To Do For Kids: " + base_title
        #base_title + " | Fun Travel and Activities for Kids"
      else
        "#{page_title} For Kids: Activities and Reviews"
      end
    else
      if category.eql?("beach")
        page_title+" : Things To Do for Kids"
      elsif  category.eql?("sports")
        page_title+" : Institute of Sport things To Do : Bound Round"
      elsif  ["place_to_eat", "place_to_stay"].include?(category)
        page_title+" : For Kids : Bound Round"
      elsif  category.eql?("transport")
        page_title+" : Cableway Things To Do : Bound Round"
      elsif  category.eql?("area")
        page_title+" : Things To Do By Kids For Kids : Bound Round"  
      else
        page_title + " Things To Do : Bound Round"
      end
    end
  end
  
  def body_title(title= '', category='')
    if category.empty?
      if title.empty?
        "Activities, Reviews and Things To Do For Kids: Bound Round"
      else
        title+" : Activities for Kids"
      end
    else
      if category.eql?("beach")
        title+" : Activities and Reviews" 
      else
        title
      end
    end
  end

  def meta_description(title='', category='')
    if category.empty?
      if title.empty?
        "Find things for kids to do, reviews and activies to do in destinations around the world, see videos and share stories to earn points and redeem them for great rewards."
      else
        title+". Learn interesting facts about Australia, uncover fun things to do, activities, read reviews and watch videos full of insider tips by kids."
      end
    else
      if category.eql?("beach")
        title+" : activities, reviews & videos about things to do. Kids, sign-up to share your experiences and earn points you can use for great rewards." 
      else
        title+" : videos, reviews & stories about things to do. Kids, sign-up to share your experiences and earn points you can use for great rewards."
      end
    end
  end
  
  def draw_hero_background(place)
    if place.photos.blank?
      if place.categories.blank?
#        "https://d1w99recw67lvf.cloudfront.net/category_icons/large_generic_sights.jpg"
        "data:image/png;base64,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"
      else
        '"https://d1w99recw67lvf.cloudfront.net/category_icons/large_generic_' + place.categories[0].identifier + '.jpg"'
      end
    else
      place.photos.find_by(priority: 1) ? place.photos.find_by(priority: 1).path_url(:large) : place.photos.first.path_url(:large)
    end
  end

  def draw_small_background(place)
    if place.photos.blank?
      if place.categories.blank?
        "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAPoAAACRCAYAAADq36WkAAAKq2lDQ1BJQ0MgUHJvZmlsZQAASImVlwdQU9kax8+96Y0WupTQO9Kr9BqKIB1shARCKCEEgoINEXEFVhQREVAXVKQouCpFFhWxYFsELNg3yKKgrGIBVFTeBR7hvTdv5837Zk7uL99897v/c+45M/8LAPkeg8dLgiUASOam84O8XGkRkVE03B8AD7BADBgCOQYzjecSGOgH/jYmHwBo9nrXaLbX39f915BkxaYxAYACEY5hpTGTET6LjA4mj58OAIqH5DXWpfNmuQRhaT4iEOHaWWbPc8csx8xz71xNSJAbwn8CgCczGHw2AKRxJE/LYLKRPmRktsCEy+JwEXZG2JEZz2AhnI2wYXJyyiyfQFg35l/6sP+tZ4yoJ4PBFvH8XOYC785J4yUxMv/P5fjfkZwkWHiGOjLI8XzvoNk5I2tWm5jiK2JuzPKABeaw5urnOF7gHbrAzDS3qAVmMdx9F1iQGOqywAz+4r2cdHrIAvNTgkT9Y9M8gkX9Y+l+Ig1Jy0Ucx/GkL3BWfEj4AmdwwpYvcFpisO9ijZsozxcEiTTH8T1Fc0xOW9TGZCxqSI8P8V7UFiHSwIp19xDluaGiel66q6gnLylQVB+b5CXKp2UEi+5NRzbYAicwfAIX+wSK1gf4AS9AA54gFCE/hLyBe3rs+vRZwW4pvEw+hx2fTnNBTkwsjc5lGhvSzExMLQGYPX/zr/fjw7lzBcniF3OpyPuyQ9YRTl7MRSPPb0P2nwRzMadliGyNbgA6VzMF/Iz5HHr2BwOIQBxRqABUgAbQBUbADFgBe+AMPIAPCAAhIBKsAUwQD5IBH6wDG8FWkAcKwG6wD5SDw+AIqAUnwWnQCjrAJXAN3AK94D54AoRgGLwB42ASTEMQhIMoEBVSgFQhLcgAMoNsIEfIA/KDgqBIKBpiQ1xIAG2EtkEFUDFUDlVBddCv0DnoEnQD6oMeQYPQKPQB+gqjYDIsDSvD2vBS2AZ2gX3hEHg1zIZT4Sw4F94Fl8HV8Am4Bb4E34Lvw0L4DTyBAigSShalhjJC2aDcUAGoKFQcio/ajMpHlaKqUY2odlQ36i5KiBpDfUFj0VQ0DW2Etkd7o0PRTHQqejO6EF2OrkW3oK+g76IH0ePoHxgKRgljgLHD0DERGDZmHSYPU4qpwTRjrmLuY4Yxk1gsVharg7XGemMjsQnYDdhC7EFsE7YT24cdwk7gcDgFnAHOAReAY+DScXm4A7gTuIu4ftww7jOehFfFm+E98VF4Lj4HX4qvx1/A9+Nf4acJEgQtgh0hgMAiZBKKCEcJ7YQ7hGHCNFGSqEN0IIYQE4hbiWXERuJV4lPiRxKJpE6yJa0gcUjZpDLSKdJ10iDpC1mKrE92I68iC8i7yMfJneRH5I8UCkWb4kyJoqRTdlHqKJcpzymfxahixmJ0MZbYFrEKsRaxfrG34gRxLXEX8TXiWeKl4mfE74iPSRAktCXcJBgSmyUqJM5JDEhMSFIlTSUDJJMlCyXrJW9IjkjhpLSlPKRYUrlSR6QuSw1RUVQNqhuVSd1GPUq9Sh2WxkrrSNOlE6QLpE9K90iPy0jJWMiEyayXqZA5LyOURclqy9Jlk2SLZE/LPpD9Kqcs5yIXK7dTrlGuX25Kfom8s3ysfL58k/x9+a8KNAUPhUSFPQqtCs8U0Yr6iisU1ykeUryqOLZEeon9EuaS/CWnlzxWgpX0lYKUNigdUbqtNKGsouylzFM+oHxZeUxFVsVZJUGlROWCyqgqVdVRlaNaonpR9TVNhuZCS6KV0a7QxtWU1LzVBGpVaj1q0+o66qHqOepN6s80iBo2GnEaJRpdGuOaqpr+mhs1GzQfaxG0bLTitfZrdWtNaetoh2vv0G7VHtGR16HrZOk06DzVpeg66abqVuve08Pq2egl6h3U69WH9S314/Ur9O8YwAZWBhyDgwZ9hhhDW0OuYbXhgBHZyMUow6jBaNBY1tjPOMe41fjtUs2lUUv3LO1e+sPE0iTJ5KjJE1MpUx/THNN20w9m+mZMswqze+YUc0/zLeZt5u8tDCxiLQ5ZPLSkWvpb7rDssvxuZW3Ft2q0GrXWtI62rrQesJG2CbQptLlui7F1td1i22H7xc7KLt3utN07eyP7RPt6+5FlOstilx1dNuSg7sBwqHIQOtIcox1/cRQ6qTkxnKqdXjhrOLOca5xfuei5JLiccHnrauLKd212nXKzc9vk1umOcvdyz3fv8ZDyCPUo93juqe7J9mzwHPey9Nrg1emN8fb13uM9QFemM+l19HEfa59NPld8yb7BvuW+L/z0/fh+7f6wv4//Xv+ny7WWc5e3BoAAesDegGeBOoGpgb+twK4IXFGx4mWQadDGoO5gavDa4PrgyRDXkKKQJ6G6oYLQrjDxsFVhdWFT4e7hxeHCiKURmyJuRSpGciLbonBRYVE1URMrPVbuWzm8ynJV3qoHq3VWr199Y43imqQ159eKr2WsPRONiQ6Pro/+xghgVDMmYugxlTHjTDfmfuYbljOrhDUa6xBbHPsqziGuOG6E7cDeyx6Nd4ovjR/juHHKOe8TvBMOJ0wlBiQeT5xJCk9qSsYnRyef40pxE7lXUlRS1qf08Qx4eTxhql3qvtRxvi+/Jg1KW53Wli6NGJ3bAl3BdsFghmNGRcbndWHrzqyXXM9dfztTP3Nn5qssz6xjG9AbmBu6Nqpt3LpxcJPLpqrN0OaYzV1bNLbkbhnO9squ3Urcmrj19xyTnOKcT9vCt7XnKudm5w5t99rekCeWx88b2GG/4/BP6J84P/XsNN95YOePfFb+zQKTgtKCb4XMwps/m/5c9vPMrrhdPUVWRYd2Y3dzdz/Y47SntliyOKt4aK//3pYSWkl+yad9a/fdKLUoPbyfuF+wX1jmV9Z2QPPA7gPfyuPL71e4VjRVKlXurJw6yDrYf8j5UONh5cMFh7/+wvnlYZVXVUu1dnXpEeyRjCMvj4Yd7T5mc6yuRrGmoOb7ce5xYW1Q7ZU667q6eqX6oga4QdAwemLVid6T7ifbGo0aq5pkmwpOgVOCU69/jf71wWnf011nbM40ntU6W9lMbc5vgVoyW8Zb41uFbZFtfed8znW127c3/2b82/EOtY6K8zLniy4QL+RemLmYdXGik9c5dol9aahrbdeTyxGX711ZcaXnqu/V69c8r13udum+eN3hescNuxvnbtrcbL1ldavltuXt5t8tf2/useppuWN9p63Xtre9b1nfhX6n/kt33e9eu0e/d+v+8vt9D0IfPBxYNSB8yHo48ijp0fvHGY+nn2Q/xTzNfybxrPS50vPqP/T+aBJaCc8Pug/efhH84skQc+jNn2l/fhvOfUl5WfpK9VXdiNlIx6jnaO/rla+H3/DeTI/l/SX5V+Vb3bdn3zm/uz0eMT78nv9+5kPhR4WPxz9ZfOqaCJx4Ppk8OT2V/1nhc+0Xmy/dX8O/vppe9w33rey73vf2H74/ns4kz8zwGHzGnBVAIQOOiwPgw3EAKJEAUBHfTBSb98dzAc17+jkCf8fzHnourAA4hlxCOwGYtW1VzgBoz9pT5H8gwiHOADY3F41/Rlqcudl8L1IrYk1KZ2Y+Ir4QpwfA94GZmenWmZnvNYjYx4iPmZz35bOhgnwjRLUDyMq2951uNviP+Ae4GgMCAeDdsQAAAAlwSFlzAAALEwAACxMBAJqcGAAAAgRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOnRpZmY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vdGlmZi8xLjAvIj4KICAgICAgICAgPGV4aWY6UGl4ZWxZRGltZW5zaW9uPjE5NTwvZXhpZjpQaXhlbFlEaW1lbnNpb24+CiAgICAgICAgIDxleGlmOlBpeGVsWERpbWVuc2lvbj4zMTI8L2V4aWY6UGl4ZWxYRGltZW5zaW9uPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KY593zgAAGwVJREFUeAHtXYuW5KoKnb6r//9H5x/OXNGQIAK+UyZln3UmirDZbDSpqu7p+fn79+9/f/bX0gr8+/dP5ffz50dds5b0oDVXLA1yjH9+DI1ywYut53TQav3fYnVsOluBrcAEBfZBnyDqhtwKrKbAPuirdYTxyb1U+/dHf1nPoPb0CxTQ9ss+6F/Q/F3iNykgfx6x5EGf9YyahTtrGxmfwUUp1af60wqOqrompTpcEfFIe8rFXuvPyuqQm/5b8spP3UiHNvDJL/iYnwAX6EjzyHThboUr8p0rTYP+YeWahfhSFIgOsRdCnKuuelrrhUPru6wlI8RLWGh0Hahdj501yWO7q6s6h3YtpGTXIaEdT8UpqStoffEriQFOeq2UMeeH85QrjaLjuFaI+/nzSx3oGDcOtWnjGt8+DFosHWuolj3EBxlQzNT/8krXYsulQq7xl2eMgFuBW2vmgN2evzwT1pDLZSEihuzT218ZtVfjixUdhbGlhV0r5XrhBiufU9/cGGP//Rn60r28mJhga1yM0j4bnR/llRiNzvWpHJi3tZ7WOMw765rnZXVXZpXHlONGWoce9JHE1sGqb+w63DeTFgXe2PHhB73m7gW+Nf4tTeuJaW94e2QPXxqr6arZaezs8Qoc7Brl/snWCym3fnnePxp+0KGElQu+X+KdcSvweQWmHHQ46rm7dm7989LAZ5Vv/HpnVSt0amVl1U/dRwj3hMM8os6NsRVYXYFJT/TVyy7j9863IO+sqqyjc71WVnYfdKP3o1+KrbERRlcV3qgZMr5oye6gpKwdcZ80+6BP0Vpq+Rrv+WVmfSJYPygiIdf6SxhzbbJKLbxlpLnsJfR90CVVXmxb5QmztsTvU2kf9LV33HB24QmzynNmeHmDAN+nzz7og7bGk2BgG7e8DH1SjZtrrMCv+M3iQa9crM00/1tvIXt1HryZD9IglnutGfanWqOWMr5I1xZ5ZsfIT3RsSmN22EC4iTSI3LoWV2a/0AOTwoKoGx2XJX2s16XWhBJAR6olHU9INwbyfXd5+aCPUSuLMmuDSXspm0sOytbwFoesPiMLlbQeid+NtTzB6go/etCr2RYFtDVJvofL1jyN1rg88hs8bnmr0CWU3D/Z2pXotmD5oD+5oqF/pabtpnFb95ZJ9OgNU6Hic+tMD3pnLbe+BBRbtA+nKMtU47do/tw6i35nXM0egZdlnz/sNYyD73NbWF/rjvg+BdIn+uM16HxJ8vj62wroe9/8LZo/t84XHvS2jf7tUX2vwr7l9dBz69wH/dtP+K7/KxT4+EHve5JIPVrhrrsCB0mbNWzjez66rvf17+MHfY0WjW2shbbyJm/hZsZYQoxu/EA8jbZmz6U2NcoFD1pf4qCPEiKHk1uXNK2NqfWXcn7SNox/5lQMyzNYrBwvbV2zD6bXDPfr/vmWqCXuH1Lv+mgRC+a4EkOa64zzjvq36IBcRFgCBhs6sWowjxZGeSM/KQZhMY2E5z7JDsvOGbECNfgnrC6KUizY+j4JD6hnPY4J5RDlxGIOI60Xv11axBf2EgrCMDGf53CsXc7hNwdjKPridYQONBfiwtWqy+ofxaDjXIyUD214pXh0XK5DWm3yRIeNcW4OmqVi3BMPzU5pXsm1zXB5eIBrGgCvuTKqrTsHezYc8jlnmFNdSuqwdFDKiMw+HyFK80eOBhnkYLh4qDNXBJxONA4WPnJI0cosVryWV+pfWbbDywHznsOKlA9teNXyWHVcMbJXctCvgLaRK644UGt6MUCNY05FAetWfkJ+MMltU5x7zA36ROl64yOwZ06im8OHStDaIB70msP6oXp22tEKlN+fR2feeDcoIB70G/LuFKspoD0KVuO5+TQpkBx0eJqrH9oUpgAM/qqAzwGqN49Khz+dYM5tLFjiItlYmDp1L7mTjLV4ko5qQmGhKl/CVgC0TIXxVZyOfNLesajwtaZ4Xg+f8yRuPqLnAuxpKqkj7Jkz5Bz8wgKID+9H4TriPSE2k77HxRyY2c9zpw+dzys8dkBxvIYFkbPRmGsp/nQfeZ/pyIDGEDMZhkcifTBKjceAfNMoEkbVXyMOVDaEvwqLwG1+IRghIJBq52Lp0olLfcAIqcHRzgWe/V/5HPEu4lw90YMGlYwXGunNaIc4Gs0c3JSyAM44z/OnWFckavyLBeGVuveOOSaf1+OjSHgNCCgCiqLhhqi6WClGxr888zxiDhaevNZopWnpmMChlsQkDO1aXf2wQwu+yrIVAA1wCVzyvYNUl3jXyI4srZT78Xl5oVckcExeupcDred5laZxu9qieaT2+hgrIs8xZXCXpYWbGmOJ4ApS4+4qVsmT56UVptnXqPVVBx16p8utdHab5ymgNaPoaT+PVg45f9hzCOutv+6gr3HUtR2+3gZARn2bu67evlzI+P7rU3mDUi886PdvgDdktN9h5ipc/BGdo1+8/tw690EvbvJ21BWoe6LrOKuvPLfOfdBX31uP4PfcJ12dvM+tcx/0uk5v763AIxXYB/2RbduktwJ1CuyDXqfXa72f/Inya5sysLB90AeK+b1QlR9SVbp/r67jKt8HfZyWj0ba3157dPuy5PdBz0q0HbYCz1dgH/Tn93BXsBXIKrAPelai73DYH8a9u8/7oL+7v8XV9b1H35+uFQv9IccXHvQVfnppBQ537qi6et3vJbiTXEMumZ9sbYD/QMjrDvr4ZtQj1kd8oPN3pHyoEA+lbXb0dQfdrFZZNJ8wg7ve9xJZKWCQuYWbGpPRzdR8UD0tMGo9J5hWmGaPfz3UCXPzIPqXWvp/1VPMnv7OuHjl+h1jIGzPB0G+MbrG0V9PxybCO0p49fjPDXKvIj00cXI18VKiOeaIjDg5ePqaMzgYMvQK+X3xBJWV47kV/voOqVbXy1Alw4WMfH/hYc9pSthOGyKXs3TUimZ0tvArP2FwLAh10hD0C7q6lU/03aX9paTwYPKGUJ+SMeJIvufm8L+TEmVD1aQIw1YSJvigiZxfn4TzlnTwGyLX3IPyuemPuav9jDw3llubudEjDi57UhOKcTKDPYzGg3jBxWuXCQOfJL/DRi1m6qDWxDkfc18Pq9v3T/FHVx4X9RyccNMRvTEWrj0PPYrDx+JLd06WB7XOuUaz8rTwk7hINo/NCxESSrGSDUJxowswXSYtnwhaUJMYh8bC+CpOiN15VQ95Jy4Pl2qTbD5O0WsWV/Gg8wL2/JkKzHo6zFJj1g1vFt9ZuDMO+z7os7q1AO6MDbNAWZtCgwLiQZfeRzVgJyHhbcn15qQ7zwWV5Ko1SFwkm8ctyOtjmZ+KV0u2wB8OeVU+xrUgRexSGF/FKc7QOFNeIzeiWWFSbZLNY2T0Gn2Tjj6MAwIqMatCtoYY0vuTUN/1L1Cw0OqpyxFi3IccZ0szIl4vaeEwXCmBt8QZPDzkkYtkuoK10UnPfRBHeEUTLXaE3eX0dblPw31fgAPWTPj0pvLYDsTrh/gFoGf/CnzbXGjBAoJbpr3A3nrN/gvfQcDatP5hjEcnmp56H2kxT+QvUJphOv+llhngp0AKOBTeUzQK5+HdIQwt1XdZ6AHpBLQ4BJ08JM58M2LeHHcRi+4WSZeDvsemVAVfvixVjhwcHtI+7loC4AAT5vNQEqEjR7hn8goIAX8HPppz3GDJasVQJ3EJcsGBDbWPajlczBjnUxKDGNn9A3fkg76PMeS6KggjxyMyiS/dI4/JEyy6Jg3Uq8Vp9oCvKKWYIYYf8oBjolGXurHvDbT/aFLcqwQLlun/icPSBkP049XZqQTbtLPLsveQnH12jN8Tmf2AzPghB/vHDzqSq7sam6QOqNO7jkfJZkh6mRg6Kd8Zrshj3TyBHi+Zz+tKkEmU9ILnkZG4V93cxEwKTwzFyZY46GaxxaV8wrFdeInt+SSXFr/JdsOGWEXrmh1U4qvVtcRBr9/DJSXXo86O0JowO+/H8LU2aXZH1GskrLdrJ4A1CjIOqYBAazIlbomDrnBT1aj1V4FwofE94Ege6ka+4emGMtx1VWtFArxmPke/adeRnW0kKdUs2Tg8+Ah+ybfXeBzOtea0vNdBTLhquNRHGkOclNvCwzUeZ7UVPtjwupFPfhFH4pWzSbxPPKFBFA95n/50cfQYRUFOMIcxXnP5MF7x87oSTcEtqgvzKvEjzGYvlARSDLhG3FmsFGP5n+E9GrDY30Ai9O9M4AbYU2qTxkWEPV74toWJSzcHI6rmpjGSk2Ar5YyhPkXjUx8x6DXkZ0pk6sVDDjjXuKKSBp08ZxqHY7zSopC/tEb9yDj6dBjjyfodQ69gjjNrVbHqJK44BoserId/6S7VKdmQQ8sVC1Vx+QKfS0lLfKS4JWzl5K+DzYlndgOkwP956Oh5b55MvK5BrpCMRrlwWAduLV+tcS25MjHFL90zOHt5kgIDtukkZi+AXeggzlZziQ/jZhf5bHz7qLc/6RZUxS51POG785VW0MFLC90HvVT8D/hpTeNUSv143LfM36JPWR2yV9NLd4Aa/qrHgVY/nVxM9sMUSpaOO3Y5wEhfpiZJ7sPgLqHu8CkGjsPHoVIWyYbK4Schhw8lSsklXJw/s52h+Mk4xJ8+LA+kOwPcmOaCtdyXi6UVYJoASYFzQNo6oh/75XDzyK6+ZA8hAYTjc7TjlVKktQtx/qcCzw920eEAOHH4XoBE5yJmVa+0WogDtOxBD/BpktgSdoHQfpUMX7jI8RV77uM8GSM7JevGUS4nOu2Nli3sdwqUesKqiUbCw5AYIlbUnubRLaEykQOH5HMAPWyRPpgM/f3VyIM4JaJCSryRHHkwN6bD9KOuiE/xvO1IeGrHCZC5hFEVF9VMgE9SNIO0fjpmBiEW0MyX7iFdSaILMJNZXKZliQ5FRkCxuQYP5uNEt+JgI4bNyOIUTjZauMlY+RTYKnMPfk1sqFXRRTFjIZeuaFnjmqtfW9fsUBVIYa3fUbl60O8iNjpPE15mU9Y3YjhgNYUWHVpiTGKKDIrZhLpzUeOn2fPc2iPz2GUe6kEvC0+9ajbL58u/+Etc+MvKy7ttJOVoQ9pRcxVo65QUJdnmcpfRhx90Oc22vlmBmpu71yF6j/okZVY5tvWa7YNer9mO2Ao8ToF90B/XsjmEq5/Kc2hs1EkK/M9/bwm+FYL/T0okwRZ+B0YKvcV2fsvklmyfTfJNtc5SeuX9nD7RV2Y7q0MOVyxbNLaTGAzXTkSI7Hmif89Nor6D9RFCcwaY0oMOoKuwG1DghihT4HsOa5keb/OSD/qNVb5zg+07pbWFor+Hbjl+bE3un2z9GMmqxPpBP38etwrPvRj4rBzj89fXUx9Rp/FjvB8qxENpm9tCPehQbO2dt/WQtcbxylpxrDob73ec2jlv5XgCTBy0cGuJgRIszSeWmIXO1yPfBqw4ay1LaJDDr/vpr5O5Ez/9iQDc6Q0/5ECxOV+eC8TIfSCEPngFTC/iWQHP4uakIu97mKAsKAnLEyJPE92U2k/LeR/MBXxwfKK4wcHT80/0pEXgr92SQChg5ZjywnQsxaURWyCp0IeYzqHvuYbN9hfqGmuKwQAJHCjpM03DAHE4foBCLmff0J1mcrZwQmBwLOgy0Ui/T/1Jw75jPAChzUVQbbF6AAppCpMxHIiP/vYaHkxX9Il48QFCEJL/Opt9Bqcx7lC7NFce8KBFarnQB6+gk/klrKOJH3KsH/E4P7A7Gy6nV7rkxgnesU0SnETXAAQ15m5+KYnYAjqfFpcnqelaPd1gcOobWfXJWauCB5Hgk+R39lNTRQdg06cDVsPJublgQq5wpV8OBe7A8RebnzocXrRe7yrtH247dKDQMA7JE5FiPm6G1dIF8aU7J3sG0MynURgU+ql5BEjRVJhHjGVGiYtkY2HqVIqVbB7AqENqmpqULaj5mN+dU5OToUMPx0mwCSWpNsmWBHKDQlgxR9HafhEPehT5qUlJVZ/idmPevifZjUR3qnEK5B/aai4tdN2DrjFWS3zngnaHfme1uyqvQMdDTgsVDzp9XzFTejVP6SEv9SsoQuIi2QqgQq/Y5w9gVPGUOsDc80RX83mGn/nD5GTo0MPW1FDJ2ZJPqk2ymdih6aKLWccRofkkB10lZhDgrABDxeHOZO5TuE8gw3+wyen/MBM2fjD7NfGPGOQC9FhxRAln957LY8CVjj0S5oIJ4+WezJEF4z0GoUEhEhDiVzx0gJjbrC9iF9A9l6POc4yJvcFNjivk8HlgXvmFWmAYQmCKETpcWJglXP1eg56yL6rVWRv4SEAYjtcDK9LjWPO1EhgPBxqDjfGgcHR8wKuXgBaWMe7n79+//6kRsICephNZ1F47EBdpyIuUfHI2J6zpQgWgjq6pdJqMg/5lQuQ4ALjGI0ncaSjhwlPUcjNz2LImG5tz+cTcrOcgJGmUi5Ni7qwveaJHycv2dhTSMhlxyCEviNlC2cpfc8iRg6VBG0MLcdxaC7eWGK8Te3qNq6IPKVePtq7Zfa1Nu7KvDh6tH/SWExOq4jkePq8Xoj7i4RJp9B8qhHVotVJXt+sH/Q7mbiNYT9M2CivsrhU4tKl3R9T4nt/Buv5d7D2syrLIB33v0zL1ttdW4CEKpAddOOSCyS4PAnJBuXU7w/BVkY5obE89GK6dyODIN77UlSWq72B9hJy51/prHUjawBLCySePJUG9FUyMp/VPTLME9DfVOktw2O6ZbzTMSp3FTZ/oR8hufFa7VzkkN+lXVbeLUQ96izT75tCi2o7ZCsxXYOhBB7r7sM9v2owMu28zVF0Hc/hBryltzlv4tndJUlTuJ+b0WiW0dd+/QR09L93VWFmG6++f6wIuuaLWebCVypVsnyjOOOjtFOcc4DJ5mlhbPwJrrSmULA65zaJA3mJu4dYSE4qxVLqlXDVJe00y5Gg8OYttVQ86tKGdILwQjI97PMPvvnGrTTa3muMrr8tWzOV1qDjsNlpALfHB/Hdfa7ipvmHzmNRB0vZXTCZ016Ja04GqrWt2JAOSfPIr+lVSEhEsgB9cyZfbeIx+rEMWWNcECbHhT+Tk82kBnAzMXXjr5jrjAgUJXbYp/LCG235KTOHhSbOakBuswZIV6uPpH1XOVz/u0YFWFkjDHj17S+ugYyZCiuKcmQ8ND+MjimlN/cKS4UCdK8fqE53jiMVxp865tUdgDTh08bASlHKvwSjwzW6yUl6aXxBOWw12g6exlGJWOcfhs3XQdk5R3pK6SnygZPBTfINZWYzlqp4VH3RADodsPJFmxObAap3igJK8JT4HatFmixmUzSo4aJuvKBHkqcmlgM7SQX04DOCslJI3K7mDlMpiHlX1qDrogDKeAr5fVznKCzOIyJm2dSvweAWqD/qcdxBzUB/fnV3AVmCQAv6g1x2zOu9SnvChCP/wrjT2dr8SCUp8kHiNL8aUXGtwa3x5bojtiYdw94so7vlAjpAfwJug1Q079apL5v4BBzxccl76+lj2qE2Y80c+6vsqBHB00BdNcLXiQgWsDvd9HlolxaJjn4uF0nUcR2jcHxM5u8QdMYZeOYcC8FJuUa2Ai7mwzkwu7/7h3zTD++o/J8A6FP6SPokWNBb0gBuZv9KF+8aZb69lKp7IE8SMxMPNc1CSxAY6SVzEUajHNyDKxCJcjBAWOZGJmd9DlYCxYgn+7KGmq5QXfRP1oEQsQQp0Nh9rSkEBTEclQ96M/KknvqpIajqcpBhYArsagzezhjIAM4TVBsdsMgedSvChMe03UMB5bd0mfQBDYObYkMdAY+DxNG4NrLU2OcYtnWmbuDQ+8jNE8JJmdI270ftPMkXMHjQJKtA/S3qU7qM/f6o/jHuQSuVUM5uuHGi8Z7zhx+OviChtVPVGvGIBQzjJKuSgtah90C3lFr4BWLSXWdv6Nbdi9A1+/ZfuXKq9ebgiz5vje1aBufZEElxvNz156y37RD8brqh7rrN2a/bgJt8n1Rjnrq6xvNfUjtBWNfuFO3/UwqEpRv1LQnJ/oHJ9JaeLFSmtQUWSHTnIa7gqsdHwJF+w1fprONS+5BM9KbTysNMC6Ti06GqU9UlpHBfH0LUwThinLsQC3qW5SdgtQ1pJkD0Vn/qYpC7ZEjfEQB0gi+GexI8whHxX1sDFRqYxNZxpvXIGiix79FgXO+goR09JR+zVP/XbYy3ZWmKkakbhSNhFNqoPBKTn+Th43LEIPTgVnATUIZdFoFdIpIDEgYRcCoGbbky1OUq55PyWeekOAuSanSvmXOdAfH467sGpwNbolOKNg0UO+g277IYUb9wgXTVtzbvkGxm8yEEfWVIjlvTaULI1wreGwfvGx35p1DW7WWhTkIn4xkVNpUUOukavsRUSnGTj8NSHjrnfTfNbD/msegGXYtNxoY69OvTGF9Kc7lZWh+y1zIdxF73weg/+vPbENUI1rXf0Hgv+BoEHkWIBJeRBvPOaup9LswaYMtQMszCalc/jujT+L1mAykjgSEi1RTawRMeHa/mF5eCBof8hM+YJIZlADqTMcX/x2qAqalPCh5lpnQiK9eIcr+AL3Op1uKoFLNhNyxx0LA53Xa69WMoVx0cOQQHhwlmN5r48Szq30IK3xv2ie41S/H7LmV9Jc64fqagbHcNyvlqdL88DDUN8vOrRbStXhiue2nL1BF4SOzuS5qB1IgsJEdbiOPQuvV5sF3npXkr8E35aCzQudmtq0bQsrfbR+e1qdZatcTrimBXgZWukrWp29XkzhnAhyj7oTqhcawu1JG560z/dduUNC+E+fzhe7/mcIYPVVZtBe6SNW766D3q5Vt2en293dwkiwFMPrliMN2qd0uz1SHrEnJV90OfoKqKu8DQViXUa7XenneBLhdd3sD5iTsH7oBu61t+/DTC3NBrPznbf6vue6Jp2dgelVcmmoc+074NuqDv6bjwaz6BuLsETeORTeCSWSfzji3YHpVXJ9okyHnTQQbJa2Wr94xaMvhuPxovZ1s/CAe3TCLLuJ3rQXuqvZKvvVH/Egt9Hj4tKnxb53x8Wx4SNHAQ3ZBf2+49zNyJiogUzSDESryBl1iWUndfUAor1Zp6Crh/9daiMXt3U7qBUqh1Rl73H+0FP9J4y22JHH8rReG1VjY+qf6I/VQmbt7Qq2cZ3II+49EHXnhSa3SpXutta/rCm/iKUXKDyFqOFQzbVIIcWTTG1GqsUPOvfWEM+/VeZuFrnkVCKkmz9/OoRlj7o9eXsiK3ACAVWeQ6PqCVg7IM+TsuN9BoFVnkOjxP0/14KDSCd7ieIAAAAAElFTkSuQmCC"
      else
        '"https://d1w99recw67lvf.cloudfront.net/category_icons/small_generic_' + place.categories[0].identifier + '.jpg"'
      end
    else
      place.photos.find_by(priority: 1) ? place.photos.find_by(priority: 1).path_url(:small) : place.photos.first.path_url(:small)
    end
  end

  def open_graph_image
      placeholder = "https://blooming-earth-8066-herokuapp-com.global.ssl.fastly.net/assets/br_logo_new-30eb3b9bb0267503159d6cab93191844.png"

      if @place && !@place.photos.blank?
        photo = @place.photos.first.path_url
      elsif @area && !@area.photos.blank?
        photo = @area.photos.first.path_url
      elsif @country && !@country.photos.blank?
        photo = @country.photos.first.path_url
      end

      if photo
        return "<meta property='og:image' content='#{photo.gsub('https://', 'http://') }' />\n" + "<meta property='og:image:secure_url' content='#{photo}' />\n" + "<meta property='og:image:type' content='image/jpeg' />"
      else
        return "<meta property='og:image' content='#{ placeholder.gsub('https://', 'http://') }' />\n" + "<meta property='og:image:secure_url' content='#{placeholder}' />\n" + "<meta property='og:image:type' content='image/jpeg' />"
      end
  end

  def get_random_place_photo(place)
    if place.photos.length > 0
      photo = place.photos[rand(0...place.photos.length)]
      if photo
        photo.path_url(:small)
      end
    else
      "generic-grey.jpg"
    end
  end

  def extract_domain(url)
    domain = ""
    if !url.blank? && url != "http://"
      if url.index("://")
        domain = url.split('/')[2]
      else
        domain = url.split('/')[0]
      end
    end
    domain = domain.split(':')[0]
  end

  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success"   # Green
      when "error"
        "alert-danger"    # Red
      when "alert"
        "alert-warning"   # Yellow
      when "notice"
        "alert-info"      # Blue
      else
        flash_type.to_s
    end
  end

  def category_color_for(place)
    case place.categories[0].identifier
      when 'animals'
        '#ff9280'
      when 'activity'
        '#fa8383'
      when 'beach'
        '#ffcf7b'
      when 'museum'
        '#7994b1'
      when 'park'
        '#9ff1ab'
      when 'place_to_eat'
        '#76a15a'
      when 'place_to_stay'
        '#a0dcda'
      when 'shopping'
        '#aab7f4'
      when 'sights'
        '#f2a1bc'
      when 'sport'
        '#d6abe8'
      when 'theme_park'
        '#9dd0f0'
      when 'transport'
        '#127fff'
      else
        '#f2a1bc'
    end
  end

  def like_icon(content)
    postPath = content.class.to_s.pluralize.downcase + '_' + 'users'
    postType = postPath.singularize
    postType = 'fun_facts_user' if postType == 'funfacts_user'
    postPath = 'fun_facts_users' if postPath == 'funfacts_users'

    if user_signed_in?
      if content.users.include?(current_user)
        return "<img class='like-icon' src='#{asset_path ('star_yellow.png')}' data-post-path='#{postPath}' data-post-type='#{postType}' data-user='#{current_user.id}' data-content-id='#{content.id}' data-liked='true' data-switch-image='#{asset_path('star_grey.png')}'>"
      else
        return "<img class='like-icon' src='#{asset_path ('star_grey.png')}' data-post-path=#{postPath} data-post-type='#{postType}' data-user='#{current_user.id}' data-content-id='#{content.id}' data-liked='false' data-switch-image='#{asset_path('star_white.png')}'>"
      end
    end
      "<img class='like-icon' src='#{asset_path ('star_grey.png')}'>"
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

  def approve_icon(content)
    postPath = content.class.to_s.pluralize.downcase
    postType = postPath.singularize
    postType = 'fun_fact' if postType == 'funfact'
    postPath = 'fun_facts' if postPath == 'funfacts'

    if content.customer_review == true
      return "<i class='disapprove-icon fa fa-thumbs-o-down fa-2x' data-toggle='modal' data-target='#thumbsDownModal' data-asset-type='#{postType}' data-asset-id='#{content.id}' data-place-id='#{content.place.id.to_s}'></i>" +
              "<i class='approve-icon customer-approve fa fa-thumbs-o-up fa-2x' data-post-path='#{postPath}' data-post-type='#{postType}' data-content-id='#{content.id}'></i>"
    else
      return ""
    end
  end

  def asset_owner_link(asset)
    if asset.place
      "<a href='/places/#{asset.place.slug}'>#{asset.place.display_name}</a>"
    elsif asset.area
      "<a href='/places/#{asset.area.slug}'>#{asset.area.display_name}</a>"
    elsif asset.countries
      "<a href='/places/#{asset.countries.first.slug}'>#{asset.countries.first.display_name}</a>"
    end
  end

  def thumbnail_for(content)
    if content.class.to_s == "Photo" || content.class.to_s == "UserPhoto"
      asset_path(content.path_url(:small))
    elsif content.class.to_s == "FunFact"
      asset_path(content.hero_photo_url)
    elsif content.class.to_s == "Game"
      game_thumbnail(content)
    else
      ""
    end
  end

  def show_place_rating(place)
    rating = place.quality_average.avg.round
    remainder = 5-rating
    text = ""
    rating.times do
      text += '<i class="fa fa-heart"></i>'
    end
    remainder.times do
      text += '<i class="fa fa-heart-o"></i>'
    end

    text

  end

  def strip_domain_from_username(user)
    if user.username.match /.+@.+\..+/i
      user.username.match(/^(.*?)@/)[1]
    else
      user.username
    end
  end

  def get_user_place_rating_from_review(review)
    if Rate.where(rateable_id: review.reviewable_id).where(rateable_type: review.reviewable_type).where(rater_id: review.user.id).length > 0
      Rate.where(rateable_id: review.reviewable_id).where(rateable_type: review.reviewable_type).where(rater_id: review.user.id)[0].stars.round
    else
      0
    end
  end

end
