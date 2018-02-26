/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-CurrentYear, Open Source Modelica Consortium (OSMC),
 * c/o Linköpings universitet, Department of Computer and Information Science,
 * SE-58183 Linköping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3 LICENSE OR
 * THIS OSMC PUBLIC LICENSE (OSMC-PL) VERSION 1.2.
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES
 * RECIPIENT'S ACCEPTANCE OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3,
 * ACCORDING TO RECIPIENTS CHOICE.
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from OSMC, either from the above address,
 * from the URLs: http://www.ida.liu.se/projects/OpenModelica or
 * http://www.openmodelica.org, and in the OpenModelica distribution.
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 */

#ifndef _OMSIMULATOR_TYPES_H_
#define _OMSIMULATOR_TYPES_H_

#include <stdbool.h>

#ifdef __cplusplus
extern "C"
{
#endif

/** API status codes */
typedef enum {
  oms_status_ok,
  oms_status_warning,
  oms_status_discard,
  oms_status_error,
  oms_status_fatal,
  oms_status_pending
} oms_status_t;

typedef enum {
  oms_modelState_instantiated,
  oms_modelState_initialization,
  oms_modelState_simulation
} oms_modelState_t;

typedef enum {
  oms_causality_input,
  oms_causality_output,
  oms_causality_parameter,
  oms_causality_undefined,
} oms_causality_t;

/* ************************************ */
/* OMSimulator 2.0                      */
/* ************************************ */

typedef enum {
  oms_component_none,
  oms_component_tlm,  /* TLM model */
  oms_component_fmi,  /* FMI model */
  oms_component_fmu,  /* FMU */
  oms_component_port  /* port */
} oms_component_type_t;

typedef enum {
  oms_signal_type_real,
  oms_signal_type_integer,
  oms_signal_type_boolean,
  oms_signal_type_string,
  oms_signal_type_enum
} oms_signal_type_t;

typedef struct {
  oms_causality_t causality;
  oms_signal_type_t type;
  char* name;
} oms_signal_t;

typedef struct {
  oms_component_type_t type;
  char* name;
  oms_signal_t** interfaces;
} oms_component_t;

typedef enum {
  oms_connection_fmi,
  oms_connection_tlm
} oms_connection_type_t;

typedef struct {
  oms_connection_type_t type;
  const char* from;
  const char* to;
  /* optional TLM attributes */
} oms_connection_t;

typedef enum {
  oms_message_info,
  oms_message_warning,
  oms_message_error,
  oms_message_debug,
  oms_message_trace
} oms_message_type_t;

typedef struct {
  oms_message_type_t type;
  const char* message;
} oms_message_t;

/** ssd:ElementGeometry */
typedef struct {
  double x1;
  double y1;
  double x2;
  double y2;
  double rotation;
  char* iconSource;
  double iconRotation;
  bool iconFlip;
  bool iconFixedAspectRatio;
} oms_element_geometry_t;

/** ssd:ConnectionGeometry */
typedef struct {
  double* pointsX;
  double* pointsY;
  unsigned int n;
} oms_connection_geometry_t;

#ifdef __cplusplus
}
#endif

#endif
