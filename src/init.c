
#include <Rdefines.h>
#include <R_ext/Rdynload.h>
#include "aster.h"
#ifdef ASTER_OLD_STUFF
#include "rraster.h"
#endif /* ASTER_OLD_STUFF */

static R_NativePrimitiveArgType ast_fam_types[4] =
    {INTSXP, INTSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_fam_styles[4] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_OUT};

static R_NativePrimitiveArgType ast_chkmod_types[4] =
    {INTSXP, INTSXP, INTSXP, INTSXP};

static R_NativeArgStyle ast_chkmod_styles[4] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN};

static R_NativePrimitiveArgType ast_chkmodd_types[6] =
    {INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_chkmodd_styles[6] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN};

static R_NativePrimitiveArgType ast_th2ph_types[6] =
    {INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_th2ph_styles[6] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_OUT};

static R_NativePrimitiveArgType ast_whatsis_types[7] =
    {INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_whatsis_styles[7] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_OUT};

static R_NativePrimitiveArgType ast_ctau2tau_types[7] =
    {INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_ctau2tau_styles[7] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_OUT};

static R_NativePrimitiveArgType ast_tt2var_types[9] =
    {INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, REALSXP,
    REALSXP, REALSXP};

static R_NativeArgStyle ast_tt2var_styles[9] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_IN, R_ARG_OUT};

static R_NativePrimitiveArgType ast_xpred_types[7] =
    {INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_xpred_styles[7] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_OUT};

#ifdef ASTER_OLD_STUFF
static R_NativePrimitiveArgType ast_rnzp_types[6] =
    {INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_rnzp_styles[6] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_OUT};
#endif /* ASTER_OLD_STUFF */

static R_NativePrimitiveArgType ast_rktp_types[8] =
    {INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, INTSXP, REALSXP};

static R_NativeArgStyle ast_rktp_styles[8] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_OUT};

static R_NativePrimitiveArgType ast_rktnb_types[10] =
    {INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP,
    INTSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_rktnb_styles[10] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_IN, R_ARG_IN, R_ARG_OUT};

static R_NativePrimitiveArgType ast_mlogl_types[14] =
    {INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP,
    REALSXP, REALSXP, REALSXP, REALSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_mlogl_styles[14] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_OUT, R_ARG_OUT, R_ARG_OUT};

static R_NativePrimitiveArgType ast_fish_types[10] =
    {INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP,
    REALSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_fish_styles[10] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_OUT};

static R_NativePrimitiveArgType ast_matops_types[5] =
    {INTSXP, INTSXP, REALSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_matops_styles[5] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_OUT};

static R_NativePrimitiveArgType ast_b2t2p_types[8] =
    {INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_b2t2p_styles[8] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_OUT};

static R_NativePrimitiveArgType ast_b2p2t_types[10] =
    {INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, REALSXP,
    REALSXP, REALSXP};

static R_NativeArgStyle ast_b2p2t_styles[10] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_IN, R_ARG_IN, R_ARG_OUT};

static R_NativePrimitiveArgType ast_b2t2t_types[9] =
    {INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, REALSXP,
    REALSXP};

static R_NativeArgStyle ast_b2t2t_styles[9] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_IN, R_ARG_OUT};

static R_NativePrimitiveArgType ast_addfam_types[3] =
    {STRSXP, REALSXP, INTSXP};

static R_NativeArgStyle ast_addfam_styles[3] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN};

static R_NativePrimitiveArgType ast_getfam_types[6] =
    {INTSXP, STRSXP, REALSXP, INTSXP, STRSXP, REALSXP};

static R_NativeArgStyle ast_getfam_styles[6] =
    {R_ARG_IN, R_ARG_OUT, R_ARG_OUT, R_ARG_OUT, R_ARG_OUT, R_ARG_OUT};

static R_NativePrimitiveArgType ast_getsup_types[4] =
    {INTSXP, STRSXP, INTSXP, STRSXP};

static R_NativeArgStyle ast_getsup_styles[4] =
    {R_ARG_IN_OUT, R_ARG_OUT, R_ARG_OUT, R_ARG_OUT};

static R_NativePrimitiveArgType ast_bysup_types[3] = {STRSXP, INTSXP, STRSXP};

static R_NativeArgStyle ast_bysup_styles[3] = {R_ARG_IN, R_ARG_OUT, R_ARG_OUT};

static R_NativePrimitiveArgType ast_origin_types[4] =
    {INTSXP, INTSXP, INTSXP, REALSXP};

static R_NativeArgStyle ast_origin_styles[4] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_OUT};

static R_CMethodDef cMethods[] = {
    {"aster_family", (DL_FUNC) &aster_family,
        4, ast_fam_types, ast_fam_styles},
    {"aster_check_model", (DL_FUNC) &aster_check_model,
        4, ast_chkmod_types, ast_chkmod_styles},
    {"aster_check_model_data", (DL_FUNC) &aster_check_model_data,
        6, ast_chkmodd_types, ast_chkmodd_styles},
    {"aster_theta2phi", (DL_FUNC) &aster_theta2phi,
        6, ast_th2ph_types, ast_th2ph_styles},
    {"aster_phi2theta", (DL_FUNC) &aster_phi2theta,
        6, ast_th2ph_types, ast_th2ph_styles},
    {"aster_theta2whatsis", (DL_FUNC) &aster_theta2whatsis,
        7, ast_whatsis_types, ast_whatsis_styles},
    {"aster_theta2ctau", (DL_FUNC) &aster_theta2ctau,
        6, ast_th2ph_types, ast_th2ph_styles},
    {"aster_xpred", (DL_FUNC) &aster_xpred,
        7, ast_xpred_types, ast_xpred_styles},
    {"aster_ctau2tau", (DL_FUNC) &aster_ctau2tau,
        7, ast_ctau2tau_types, ast_ctau2tau_styles},
    {"aster_tt2var", (DL_FUNC) &aster_tt2var,
        9, ast_tt2var_types, ast_tt2var_styles},
#ifdef ASTER_OLD_STUFF
    {"aster_rnzp", (DL_FUNC) &aster_rnzp,
        6, ast_rnzp_types, ast_rnzp_styles},
#endif /* ASTER_OLD_STUFF */
    {"aster_rktp", (DL_FUNC) &aster_rktp,
        8, ast_rktp_types, ast_rktp_styles},
    {"aster_rktnb", (DL_FUNC) &aster_rktnb,
        10, ast_rktnb_types, ast_rktnb_styles},
    {"aster_simulate_data", (DL_FUNC) &aster_simulate_data,
        7, ast_xpred_types, ast_xpred_styles},
    {"aster_mlogl_cond", (DL_FUNC) &aster_mlogl_cond,
        14, ast_mlogl_types, ast_mlogl_styles},
    {"aster_mlogl_unco", (DL_FUNC) &aster_mlogl_unco,
        14, ast_mlogl_types, ast_mlogl_styles},
    {"aster_fish_cond", (DL_FUNC) &aster_fish_cond,
        10, ast_fish_types, ast_fish_styles},
    {"aster_mat_vec_mult", (DL_FUNC) &aster_mat_vec_mult,
        5, ast_matops_types, ast_matops_styles},
    {"aster_vec_mat_mult", (DL_FUNC) &aster_vec_mat_mult,
        5, ast_matops_types, ast_matops_styles},
    {"aster_mat_vec_mat_mult", (DL_FUNC) &aster_mat_vec_mat_mult,
        5, ast_matops_types, ast_matops_styles},
    {"aster_diag_mat_mat_mat_mult", (DL_FUNC) &aster_diag_mat_mat_mat_mult,
        5, ast_matops_types, ast_matops_styles},
    {"aster_D_beta2theta2phi", (DL_FUNC) &aster_D_beta2theta2phi,
        8, ast_b2t2p_types, ast_b2t2p_styles},
    {"aster_D_beta2phi2theta", (DL_FUNC) &aster_D_beta2phi2theta,
        8, ast_b2t2p_types, ast_b2t2p_styles},
    {"aster_D_beta2phi2tau", (DL_FUNC) &aster_D_beta2phi2tau,
        10, ast_b2p2t_types, ast_b2p2t_styles},
    {"aster_D_beta2theta2tau", (DL_FUNC) &aster_D_beta2theta2tau,
        9, ast_b2t2t_types, ast_b2t2t_styles},
    {"aster_clear_families", (DL_FUNC) &aster_clear_families, 0, NULL, NULL},
    {"aster_add_family", (DL_FUNC) &aster_add_family,
        3, ast_addfam_types, ast_addfam_styles},
    {"aster_get_family", (DL_FUNC) &aster_get_family,
        6, ast_getfam_types, ast_getfam_styles},
    {"aster_get_superfamily", (DL_FUNC) &aster_get_superfamily,
        4, ast_getsup_types, ast_getsup_styles},
    {"aster_byname_superfamily", (DL_FUNC) &aster_byname_superfamily,
        3, ast_bysup_types, ast_bysup_styles},
    {"aster_default_origin", (DL_FUNC) &aster_default_origin,
        4, ast_origin_types, ast_origin_styles},
    {NULL, NULL, 0, NULL, NULL}
};
 
static R_CallMethodDef callMethods[]  = {
#ifdef ASTER_OLD_STUFF
    {"aster_families", (DL_FUNC) &aster_families, 0},
#endif /* ASTER_OLD_STUFF */
    {NULL, NULL, 0}
};

void R_init_aster(DllInfo *info)
{
    R_registerRoutines(info, cMethods, callMethods, NULL, NULL);
}

