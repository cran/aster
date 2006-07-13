
#include <Rdefines.h>
#include <R_ext/Rdynload.h>
#include "aster.h"
#include "rraster.h"

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

static R_NativePrimitiveArgType ast_ctau2tau_types[8] =
    {INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_ctau2tau_styles[8] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
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

static R_NativePrimitiveArgType ast_rnzp_types[6] =
    {INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_rnzp_styles[6] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_OUT};

static R_NativePrimitiveArgType ast_rktp_types[8] =
    {INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, INTSXP, REALSXP};

static R_NativeArgStyle ast_rktp_styles[8] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_OUT};

static R_NativePrimitiveArgType ast_mlogl_types[13] =
    {INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP,
    REALSXP, REALSXP, REALSXP, REALSXP, REALSXP};

static R_NativeArgStyle ast_mlogl_styles[13] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_OUT, R_ARG_OUT, R_ARG_OUT};

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

static R_NativePrimitiveArgType ast_b2p2t_types[9] =
    {INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, REALSXP, REALSXP,
    REALSXP};

static R_NativeArgStyle ast_b2p2t_styles[9] =
    {R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN, R_ARG_IN,
    R_ARG_IN, R_ARG_OUT};

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
        8, ast_ctau2tau_types, ast_ctau2tau_styles},
    {"aster_tt2var", (DL_FUNC) &aster_tt2var,
        9, ast_tt2var_types, ast_tt2var_styles},
    {"aster_rnzp", (DL_FUNC) &aster_rnzp,
        6, ast_rnzp_types, ast_rnzp_styles},
    {"aster_rktp", (DL_FUNC) &aster_rktp,
        8, ast_rktp_types, ast_rktp_styles},
    {"aster_simulate_data", (DL_FUNC) &aster_simulate_data,
        7, ast_xpred_types, ast_xpred_styles},
    {"aster_mlogl_cond", (DL_FUNC) &aster_mlogl_cond,
        13, ast_mlogl_types, ast_mlogl_styles},
    {"aster_mlogl_unco", (DL_FUNC) &aster_mlogl_unco,
        13, ast_mlogl_types, ast_mlogl_styles},
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
        9, ast_b2p2t_types, ast_b2p2t_styles},
    {"aster_D_beta2theta2tau", (DL_FUNC) &aster_D_beta2theta2tau,
        9, ast_b2p2t_types, ast_b2p2t_styles},
    {NULL, NULL, 0, NULL, NULL}
};

static R_CallMethodDef callMethods[]  = {
    {"aster_families", (DL_FUNC) &aster_families, 0},
    {NULL, NULL, 0}
};

void R_init_aster(DllInfo *info)
{
    R_registerRoutines(info, cMethods, callMethods, NULL, NULL);
}

